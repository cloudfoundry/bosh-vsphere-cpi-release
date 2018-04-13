require 'integration/spec_helper'

describe 'network management', :network_management => true do

  #TODO: setup is duplicating code in nsxt_spec. Remove duplication
  before do
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    @nsxt_username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    @nsxt_password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')

    @edge_cluster_id = fetch_property('BOSH_VSPHERE_EDGE_CLUSTER_ID')
    @t0_router_id = fetch_property('BOSH_VSPHERE_T0_ROUTER_ID')
    @transport_zone_id = fetch_property('BOSH_VSPHERE_TRANSPORT_ZONE_ID')

    @cloud = VSphereCloud::Cloud.new(cpi_options({
        :nsxt => {
            host: @nsxt_host,
            username: @nsxt_username,
            password: @nsxt_password
        } }))
  end

  after do
    ports = router_api.list_logical_router_ports( {:logical_router_id => @t1_router_id} ).results
    ports.each do |port|
      router_api.delete_logical_router_port(port.id)
    end
    router_api.delete_logical_router(@t1_router_id)

    ports = switch_api.list_logical_ports( {:logical_switch_id => @switch_id} ).results
    switch_api.delete_logical_port(ports.first.id)

    switch_api.delete_logical_switch(@switch_id)
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

  let(:subnet_definition) {
    {
        'range' => '192.168.99.99/24',
        'cloud_properties' => {
          'edge_cluster_id' => @edge_cluster_id,
          't0_router_id' => @t0_router_id,
          'transport_zone_id' => @transport_zone_id,

          't1_name' => 't1-test-router',
          'switch_name' => 'bosh-test-switch'
        }
    }
  }

  context 'when create_subnet command issued' do
    it 'creates T0<-T1<-Switch infrastructure' do
      result = @cloud.create_subnet(subnet_definition)

      #get created switch by name. make sure it's only one
      switch_name = result[:cloud_properties][:name]
      switches = logical_switches(switch_name)
      expect(switches.length).to eq(1)
      switch = switches.first
      @switch_id = switch.id
      expect(@switch_id).not_to be_nil

      #get created router by id
      t1_router = get_t1_router(result[:network_cid])
      expect(t1_router).not_to be_nil
      @t1_router_id = t1_router.id
      expect(@t1_router_id).not_to be_nil

      #get router port attached to created switch
      router_ports = router_api.list_logical_router_ports({:logical_switch_id => switch.id})
      expect(router_ports.results.length).to eq(1)
      @router_port_id = router_ports.results.first.id
      expect(@router_port_id).not_to be_nil
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
end