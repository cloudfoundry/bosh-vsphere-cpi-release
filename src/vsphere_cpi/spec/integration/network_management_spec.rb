require 'integration/spec_helper'

describe 'network management', :network_management => true  do

  #TODO: setup is duplicating code in nsxt_spec. Remove duplication
  before(:all) do
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    @nsxt_username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    @nsxt_password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')

    @t0_router_id = fetch_property('BOSH_VSPHERE_T0_ROUTER_ID')
    @transport_zone_id = fetch_property('BOSH_VSPHERE_TRANSPORT_ZONE_ID')

    @cloud = VSphereCloud::Cloud.new(cpi_options({
        nsxt: {
            host: @nsxt_host,
            username: @nsxt_username,
            password: @nsxt_password
        } }))
  end

  let(:configuration) {
    configuration = NSXT::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = @nsxt_username
    configuration.password = @nsxt_password
    configuration.client_side_validation = false

    configuration.verify_ssl = false
    configuration.verify_ssl_host = false
    configuration
  }
  let(:client) { NSXT::ApiClient.new(configuration) }
  let(:switch_api) { NSXT::LogicalSwitchingApi.new(client) }
  let(:router_api) { NSXT::LogicalRoutingAndServicesApi.new(client) }
  let(:pool_api) { NSXT::PoolManagementApi.new(client) }

  let(:random_switch_name) { "test-switch-" + [*('A'..'Z')].sample(8).join }
  let(:random_router_name) { "test-router-" + [*('A'..'Z')].sample(8).join }

  let(:network_definition) {
    {
        'range' => '192.168.99.0/24',
        'gateway' => '192.168.99.1',
        'cloud_properties' => {
          't0_router_id' => @t0_router_id,
          'transport_zone_id' => @transport_zone_id,

          't1_name' => random_router_name,
          'switch_name' => random_switch_name
        }
    }
  }

  context 'when create_network command is issued' do
    before do
      create_ip_block
    end
    after do
      if @t1_router_id
        t0_ports = router_api.list_logical_router_ports(logical_router_id: @t0_router_id,
                                                        resource_type: 'LogicalRouterLinkPortOnTIER0')
        t1_ports = router_api.list_logical_router_ports(logical_router_id: @t1_router_id)
        t1_ports_ids = t1_ports.results.map(&:id)
        t0_port_to_t1 = t0_ports.results.find do |t0_port|
          t1_ports_ids.include? t0_port.linked_logical_router_port_id
        end
        router_api.delete_logical_router(@t1_router_id, force: true)
        router_api.delete_logical_router_port(t0_port_to_t1.id)
      end
      if @switch_id
        switch_api.delete_logical_switch(@switch_id, cascade: true, detach: true)
      end
      delete_ip_block
    end

    context 'when range is provided' do
      it 'creates T0<-T1<-Switch infrastructure' do
        result = @cloud.create_network(network_definition)
        expect(result).not_to be_nil
        result = result.as_array

        #get created switch by name. make sure it's only one
        switch_name = result[2][:name]
        switches = logical_switches(switch_name)
        expect(switches.length).to eq(1)
        switch = switches.first
        @switch_id = switch.id
        expect(@switch_id).not_to be_nil

        switch_ports = router_api.list_logical_router_ports({logical_switch_id: result[0]})
        expect(switch_ports.results.length).to eq(1)
        expect(switch_ports.results.first.id).not_to be_nil

        #get created router by id
        t1_router = get_t1_router(switch_ports.results.first.logical_router_id)
        expect(t1_router).not_to be_nil
        @t1_router_id = t1_router.id
      end
    end

    context 'when netmask_bits are provided' do
      let(:network_definition) {
        {
          'netmask_bits' => '24',
          'cloud_properties' => {
            't0_router_id' => @t0_router_id,
            'transport_zone_id' => @transport_zone_id,
            'ip_block_id' => @ip_block.id,

            't1_name' => random_router_name,
            'switch_name' => random_switch_name
          }
        }
      }

      it 'creates infrastructure and allocates subnet' do
        result = @cloud.create_network(network_definition)
        expect(result).not_to be_nil
        result = result.as_array

        #get created switch by name. make sure it's only one
        switch_name = result[2][:name]
        switches = logical_switches(switch_name)
        expect(switches.length).to eq(1)
        switch = switches.first
        @switch_id = switch.id
        expect(@switch_id).not_to be_nil

        switch_ports = router_api.list_logical_router_ports({logical_switch_id: result[0]})
        expect(switch_ports.results.length).to eq(1)
        expect(switch_ports.results.first.id).not_to be_nil

        t1_router = get_t1_router(switch_ports.results.first.logical_router_id)
        expect(t1_router).not_to be_nil
        @t1_router_id = t1_router.id
      end
    end

    context 'when failed to create a switch' do
      let(:network_definition) {
        {
            'range' => '192.168.99.0/24',
            'gateway' => '192.168.99.1',
            'cloud_properties' => {
                't0_router_id' => @t0_router_id,
                'transport_zone_id' => 'WRONG_ZONE',

                't1_name' => random_router_name,
                'switch_name' => random_switch_name
            }
        }
      }

      it 'cleans up router' do
        expect {
          @cloud.create_network(network_definition)
        }.to raise_error(/Failed to create network. Has router been created: true. Has switch been created: false/)

        fail_if_router_exist(random_switch_name)
      end
    end

    context 'when failed to attach switch to t1 router' do
      let(:network_definition) {
        {
            'range' => '192.168.200.0/32',
            'gateway' => '192.168.200.1',
            'cloud_properties' => {
                't0_router_id' => @t0_router_id,
                'transport_zone_id' => @transport_zone_id,

                't1_name' => random_router_name,
                'switch_name' => random_switch_name
            }
        }
      }
      before do
        @t1_router2 = create_t1_router('t1-test-router-2')
        @test_switch2 = create_switch('test-switch-2')
        #attach switch with subnet 192.168.200.1
        attach_switch_to_t1(@test_switch2.id, @t1_router2.id)
      end

      after do
        router_api.delete_logical_router(@t1_router2.id, {force: true})
        switch_api.delete_logical_switch(@test_switch2.id, {cascade: true, detach: true})
      end

      it 'cleans up router and switch' do
        expect {
          @cloud.create_network(network_definition)
        }.to raise_error(/Failed to create network. Has router been created: true. Has switch been created: true/)

        fail_if_router_exist(random_router_name)
        fail_if_switch_exist(random_switch_name)
      end
    end
  end

  context 'when delete_network command is issued' do

    it 'deletes switch and attached router' do
      result = @cloud.create_network(network_definition)
      expect(result).not_to be_nil
      result = result.as_array
      network_cid = result[0]
      router_id = get_attached_router_id(network_cid)

      @cloud.delete_network(network_cid)

      switches = logical_switches(random_switch_name)
      expect(switches.length).to eq(0)

      expect{
        get_t1_router(router_id)
      }.to raise_error(NSXT::ApiCallError)
    end

    context 'when t1 router has extra switches attached' do
      after do
        if @switch_id
          switch_api.delete_logical_switch(@switch_id, cascade: true, detach: true)
        end
        if @extra_switch_id
          switch_api.delete_logical_switch(@extra_switch_id, cascade: true, detach: true)
        end
        clean_t0_router_ports
        if @t1_router_id
          router_api.delete_logical_router(@t1_router_id, force: true)
        end
      end

      it 'raises an error' do
        result = @cloud.create_network(network_definition)
        expect(result).not_to be_nil
        result = result.as_array
        @switch_id = result[0]

        @t1_router_id = get_attached_router_id(@switch_id)

        extra_switch = create_switch('extra-switch')
        @extra_switch_id = extra_switch.id
        attach_switch_to_t1(@extra_switch_id, @t1_router_id)

        expect{
          @cloud.delete_network(@switch_id)
        }.to raise_error("Can not delete router #{@t1_router_id}. It has extra ports that are not created by BOSH.")
      end
    end
  end

  def logical_switches(switch_name)
    switch_api.list_logical_switches.results.find_all do |switch|
      switch if switch.display_name == switch_name
    end
  end

  def get_t1_router(t1_router_id)
    router_api.read_logical_router(t1_router_id)
  end

  def get_attached_router_id(switch_id)
    switch_ports = router_api.list_logical_router_ports({logical_switch_id: switch_id})
    switch_ports.results.first.logical_router_id
  end

  def create_switch(switch_name)
    switch = NSXT::LogicalSwitch.new({
       admin_state: 'UP',
       transport_zone_id: @transport_zone_id,
       replication_mode: 'MTEP',
       display_name: switch_name })
      switch_api.create_logical_switch(switch)
  end

  def create_t1_router(router_name)
    router_api.create_logical_router({ router_type: 'TIER1',
                                       display_name: router_name})
  end

  def attach_switch_to_t1(switch_id, t1_router_id)
      logical_port = NSXT::LogicalPort.new({admin_state: 'UP',
                                            logical_switch_id: switch_id})
      logical_port = switch_api.create_logical_port(logical_port)

      switch_port_ref = NSXT::ResourceReference.new({target_id: logical_port.id,
                                                     target_type: 'LogicalPort',
                                                     is_valid: true })
      subnet = NSXT::IPSubnet.new({ip_addresses: [ '192.168.200.1'],
                                   prefix_length: 30})

      t1_router_port = NSXT::LogicalRouterDownLinkPort.new({logical_router_id: t1_router_id,
                                                             linked_logical_switch_port_id: switch_port_ref,
                                                             resource_type: 'LogicalRouterDownLinkPort',
                                                             subnets: [subnet]})
      router_api.create_logical_router_port(t1_router_port)
  end

  def list_logical_t1_routers
    router_api.list_logical_routers({router_type: 'TIER1'}).results
  end

  def fail_if_router_exist(router_name)
    list_logical_t1_routers.each do |router|
      if router.display_name == router_name
        fail("Found router #{router_name} created by test and not cleaned up by CPI.")
      end
    end
  end

  def fail_if_switch_exist(switch_name)
    found = logical_switches(switch_name)
    fail("Found switch #{switch_name} was created by test and not cleaned up by CPI.") if found.any?
  end

  def create_ip_block
    ip_block = NSXT::IpBlock.new({cidr: '192.168.168.0/20'})
    @ip_block = pool_api.create_ip_block(ip_block)
  end

  def delete_ip_block
    subnets = pool_api.list_ip_block_subnets({block_id: @ip_block.id}).results
    subnets.each do |subnet|
      pool_api.delete_ip_block_subnet(subnet.id)
    end
    pool_api.delete_ip_block(@ip_block.id)
  end

  def clean_t0_router_ports
    t0_ports = router_api.list_logical_router_ports(logical_router_id: @t0_router_id,
                                                    resource_type: 'LogicalRouterLinkPortOnTIER0')
    t1_ports = router_api.list_logical_router_ports(logical_router_id: @t1_router_id)
    t1_ports_ids = t1_ports.results.map(&:id)
    t0_port_to_t1 = t0_ports.results.find do |t0_port|
      t1_ports_ids.include? t0_port.linked_logical_router_port_id
    end
    router_api.delete_logical_router_port(t0_port_to_t1.id, force: true)
  end
end