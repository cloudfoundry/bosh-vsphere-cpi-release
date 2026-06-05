require 'integration/spec_helper'
require 'ostruct'

module VSphereCloud
  describe TaggingTag::AttachTagToVm, attach_tag: true do
    before(:all) do
      @host = fetch_property('BOSH_VSPHERE_CPI_HOST')
      @user = fetch_property('BOSH_VSPHERE_CPI_USER')
      @password = fetch_property('BOSH_VSPHERE_CPI_PASSWORD')
      # Optional: when this env var points at a PEM bundle that signs the
      # vCenter cert, the tagging client will run with peer verification on.
      # When it is unset/empty, we fall back to verify=false so legacy
      # self-signed deployments still work.
      @ca_cert_file = ENV['BOSH_VSPHERE_CPI_CA_CERT_FILE']
      create_cat_and_tag
    end

    after(:all) do
      delete_cat_and_tag
    end

    let(:network_spec) do
      {
        'static' => {
          'ip' => "169.254.1.#{rand(4..254)}",
          'netmask' => '255.255.254.0',
          'cloud_properties' => { 'name' => @vlan },
          'default' => ['dns', 'gateway'],
          'dns' => ['169.254.1.2'],
          'gateway' => '169.254.1.3'
        }
      }
    end

    let(:vm_type) do
      {
        'ram' => 512,
        'disk' => 2048,
        'cpu' => 1,
        'tags' => tags
      }
    end

    context 'when create a vm and attach a single vm-associable tag to it' do
      let(:tags) { [{ 'category' => 'category-name-a', 'tag' => 'tag-name-a-1' }] }
      it 'created a vm with tag attached' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach multiple vm-associable-and-multi-cardinality tags to it' do
      let(:tags) do
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1' },
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-2' },
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-3' },
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-1' },
        ]
      end
      it 'created a vm with tags attached' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1', 'tag-name-a-2', 'tag-name-a-3', 'tag-name-c-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach a vm-non-associable tag to it' do
      let(:tags) { [{ 'category' => 'category-name-b', 'tag' => 'tag-name-b-1' }] }
      it 'created a vm without tags attached' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, [])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach multiple same-category-single-cardinality tags to it' do
      let(:tags) do
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1' },
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-1' },
          { 'category' => 'category-name-c', 'tag' => 'tag-name-c-2' }
        ]
      end
      it 'created a vm without same-category-single-cardinality tags' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when create a vm and attach wrong category tags to it' do
      let(:tags) do
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1' },
          { 'category' => 'category-name-d', 'tag' => 'tag-name-d-1' },
        ]
      end
      it 'created a vm with correct category tags attached' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    context 'when creating a VM and attach a non-existent category to it' do
      let(:tags) do
        [
          { 'category' => 'category-name-a', 'tag' => 'tag-name-a-1' },
          { 'category' => 'category-name-d', 'tag' => 'tag-name-d-1' }
        ]
      end
      it 'created a vm with correct tags attached' do
        begin
          test_vm_id, _ = @cpi.create_vm(
            'agent-007',
            @stemcell_id,
            vm_type,
            network_spec,
            [],
            {}
          )
          mob_id = @cpi.vm_provider.find(test_vm_id).mob.__mo_id__
          expect(test_vm_id).to_not be_nil
          expect(verify_tags(mob_id, ['tag-name-a-1'])).to be(true)
        ensure
          delete_vm(@cpi, test_vm_id)
        end
      end
    end

    after(:each) do
      if @tag_client
        @tag_client.logout rescue nil
        @tag_client = nil
      end
    end

    context 'TagClient TLS handling against the live vCenter' do
      # Targeted, lightweight regression test for TNZ-101747:
      # when an operator pins a CA bundle, the tagging client must trust it AND
      # successfully open a CIS tagging session.
      it 'opens a CIS session when a valid CA bundle is pinned' do
        skip 'set BOSH_VSPHERE_CPI_CA_CERT_FILE to run this case' if @ca_cert_file.to_s.strip.empty?

        client = VSphereCloud::TaggingTag::TagClient.new(
          host: @host,
          username: @user,
          password: @password,
          ca_cert_file: @ca_cert_file,
        )
        begin
          backing_client = client.instance_variable_get(:@http_client).backing_client
          expect(backing_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
          expect(backing_client.ssl_config.cert_store_items).to include(@ca_cert_file)

          expect(client.login).not_to be_nil
          expect(client.list_categories).to be_a(Array)
        ensure
          client.logout rescue nil
        end
      end

      it 'rejects the connection when a CA bundle does not sign the vCenter cert' do
        bogus_ca = Tempfile.open('bogus-ca') do |f|
          f.write(generate_unrelated_pem)
          f
        end

        client = VSphereCloud::TaggingTag::TagClient.new(
          host: @host,
          username: @user,
          password: @password,
          ca_cert_file: bogus_ca.path,
        )

        begin
          expect { client.login }.to raise_error(/does not have a valid SSL certificate/)
        ensure
          client.logout rescue nil
        end
      end
    end

    private

    def tag_ids
      return @tag_ids unless @tag_ids.nil?
      @tag_ids = []
    end

    def cate_ids
      return @cate_ids unless @cate_ids.nil?
      @cate_ids = []
    end

    def tag_client
      return @tag_client unless @tag_client.nil?
      cloud_config = OpenStruct.new(
        vcenter_host: @host,
        vcenter_password: @password,
        vcenter_user: @user,
        vcenter_connection_options: @ca_cert_file ? { 'ca_cert_file' => @ca_cert_file } : {},
        soap_log: STDOUT,
      )
      @tag_client = VSphereCloud::TaggingTag::TagClient.new_from_config(cloud_config)
    end

    def create_category(spec)
      tag_client.login
      response = tag_client.instance_variable_get(:@http_client).post(
        "https://#{@host}/rest/com/vmware/cis/tagging/category",
        JSON.generate('create_spec' => spec['create_spec']),
        {
          'vmware-api-session-id' => tag_client.session_id,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      )
      unless response.code.to_i.between?(200, 299)
        raise "Failed to create category #{spec.inspect}: HTTP #{response.code} - #{response.body}"
      end
      JSON.parse(response.body).fetch('value')
    end

    def create_tag(spec)
      tag_client.login
      response = tag_client.instance_variable_get(:@http_client).post(
        "https://#{@host}/rest/com/vmware/cis/tagging/tag",
        JSON.generate('create_spec' => spec['create_spec']),
        {
          'vmware-api-session-id' => tag_client.session_id,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json',
        }
      )
      unless response.code.to_i.between?(200, 299)
        raise "Failed to create tag #{spec.inspect}: HTTP #{response.code} - #{response.body}"
      end
      JSON.parse(response.body).fetch('value')
    end

    def delete_category(category_id)
      tag_client.login
      response = tag_client.instance_variable_get(:@http_client).delete(
        "https://#{@host}/rest/com/vmware/cis/tagging/category/id:#{URI::DEFAULT_PARSER.escape(category_id)}",
        {
          'vmware-api-session-id' => tag_client.session_id,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      )
      unless response.code.to_i.between?(200, 299)
        raise "Failed to delete category #{category_id}: HTTP #{response.code} - #{response.body}"
      end
    end

    def delete_tag(tag_id)
      tag_client.login
      response = tag_client.instance_variable_get(:@http_client).delete(
        "https://#{@host}/rest/com/vmware/cis/tagging/tag/id:#{URI::DEFAULT_PARSER.escape(tag_id)}",
        {
          'vmware-api-session-id' => tag_client.session_id,
          'Accept' => 'application/json',
          'Content-Type' => 'application/json'
        }
      )
      unless response.code.to_i.between?(200, 299)
        raise "Failed to delete tag #{tag_id}: HTTP #{response.code} - #{response.body}"
      end
    end

    def create_cat_and_tag
      cate_config_array = [
        {
          'create_spec' => {
            'name' => 'category-name-a',
            'description' => 'category contains multi-tag, associable to vm, multi-cardinality',
            'associable_types' => [],
            'cardinality' => 'MULTIPLE'
          }
        },
        {
          'create_spec' => {
            'name' => 'category-name-b',
            'description' => 'category contains multi-tag, not associable to vm, multi-cardinality',
            'associable_types' => %w[VirtualApp StoragePod Datacenter],
            'cardinality' => 'MULTIPLE'
          }
        },
        {
          'create_spec' => {
            'name' => 'category-name-c',
            'description' => 'category contains multi-tag, associable to vm, single-cardinality',
            'associable_types' => [],
            'cardinality' => 'SINGLE'
          }
        },
      ]
      cate_config_array.each do |cate_config|
        cate_id = create_category(cate_config)
        cate_ids << cate_id unless cate_id.nil?
      end

      tag_config_array = []
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-a-1', 'description' => 'null', 'category_id' => cate_ids[0] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-a-2', 'description' => 'null', 'category_id' => cate_ids[0] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-a-3', 'description' => 'null', 'category_id' => cate_ids[0] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-b-1', 'description' => 'null', 'category_id' => cate_ids[1] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-b-2', 'description' => 'null', 'category_id' => cate_ids[1] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-c-1', 'description' => 'null', 'category_id' => cate_ids[2] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-c-2', 'description' => 'null', 'category_id' => cate_ids[2] } }
      tag_config_array << { 'create_spec' => { 'name' => 'tag-name-c-3', 'description' => 'null', 'category_id' => cate_ids[2] } }

      tag_config_array.each do |tag_config|
        unless tag_config['create_spec']['category_id'].nil?
          tag_id = create_tag(tag_config)
          tag_ids << tag_id unless tag_id.nil?
        end
      end
    end

    def delete_cat_and_tag
      tag_ids.each { |tag_id| delete_tag(tag_id) }
      cate_ids.each { |cate_id| delete_category(cate_id) }
    end

    def verify_tags(vm_mob_id, attached_tags)
      attached_info = tag_client.list_attached_tags_on_objects([vm_mob_id])
      tags_on_vm = (attached_info && attached_info.first) ? Array(attached_info.first['tag_ids']) : []
      return false unless attached_tags.size == tags_on_vm.size

      tags_on_vm.each do |tag_id|
        info = tag_client.get_tag(tag_id)
        return false unless attached_tags.include?(info['name'])
      end
      true
    end

    # Generates a PEM-encoded self-signed cert that is unrelated to the vCenter
    # in @host, used for negative TLS tests.
    def generate_unrelated_pem
      key = OpenSSL::PKey::RSA.new(2048)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = SecureRandom.random_number(2**(8 * 20))
      cert.subject = OpenSSL::X509::Name.parse('/CN=unrelated-test-ca')
      cert.issuer = cert.subject
      cert.public_key = key.public_key
      cert.not_before = Time.now - 24 * 60 * 60
      cert.not_after = Time.now + 24 * 60 * 60
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = cert
      cert.add_extension(ef.create_extension('basicConstraints', 'CA:TRUE', true))
      cert.add_extension(ef.create_extension('keyUsage', 'cRLSign,keyCertSign', true))
      cert.sign(key, OpenSSL::Digest::SHA256.new)
      cert.to_pem
    end
  end
end
