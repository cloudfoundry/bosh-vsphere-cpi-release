require 'spec_helper'
require 'celluloid/backported'
require 'securerandom'
require 'tempfile'
require 'yaml'

describe VSphereCloud::Cloud do
  include LifecycleProperties
  subject(:cpi) { described_class.new(cpi_options) }
  let(:logger) { Logger.new(STDOUT) }
  let(:metadata) { { "bosh-#{SecureRandom.uuid}-key" => "test value" } }

  before do
    logger.level = Logger::DEBUG
    config = VSphereSpecConfig.new
    config.logger = logger
    config.uuid = '123'
    Bosh::Clouds::Config.configure(config)

    fetch_properties(LifecycleHelpers)

    Dir.mktmpdir do |temp_dir|
      stemcell_image = LifecycleHelpers.stemcell_image(@stemcell_path, temp_dir)
      @stemcell_id = cpi.create_stemcell(stemcell_image, nil)
    end

    network_spec = {
      'static' => {
        'ip' => "169.254.1.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => @vlan },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }

    resource_pool = {
      'ram' => 1024,
      'disk' => 2048,
      'cpu' => 1,
    }

    @vm_cid = cpi.create_vm(
      'agent-007',
      @stemcell_id,
      resource_pool,
      network_spec,
      [],
      {'key' => 'value'}
    )
  end

  after do
    cpi.delete_stemcell(@stemcell_id) if @stemcell_id
  end

  describe 'set_vm_metadata' do
    context 'when called with duplicate keys with multiple threads' do
      it 'succeeds' do
        pool = MetadataActor.pool(size: 3, args: [cpi_options])
        expect(logger).to receive(:warn).exactly(2).times
        expect {
          3.times do
            pool.async.execute(@vm_cid, metadata)
          end
        }
      end
    end
  end

  class MetadataActor
    include Celluloid

    def initialize(options)
      @cpi = VSphereCloud::Cloud.new(options)
    end

    def execute(cid, metadata)
      @cpi.set_vm_metadata(cid, metadata)
    end
  end
end
