require 'integration/spec_helper'

context 'debug logging' do
  let(:network_spec) do
    {
      'static' => {
        'ip' => "169.254.#{rand(1..254)}.#{rand(4..254)}",
        'netmask' => '255.255.254.0',
        'cloud_properties' => { 'name' => vlan },
        'default' => ['dns', 'gateway'],
        'dns' => ['169.254.1.2'],
        'gateway' => '169.254.1.3'
      }
    }
  end

  let(:vlan) { @vlan }

  let(:vm_type) do
    {
      'ram' => 512,
      'disk' => 2048,
      'cpu' => 1,
    }
  end

  let(:password) do
    ENV.fetch('BOSH_VSPHERE_CPI_PASSWORD')
  end

  let(:logger) do
    Bosh::Cpi::Logger.new(log)
  end

  let(:log) do
    StringIO.new('')
  end

  before do
    allow(Bosh::Clouds::Config).to receive(:logger).and_return(logger)
  end

  context 'when http_logging is enabled' do
    let(:cpi) do
      opts = cpi_options({ soap_log: log, http_logging: true})
      cpi = VSphereCloud::Cloud.new(opts)
      cpi
    end

    it 'does not log credentials' do
      env = {'secret' => 'my-fake-secret'}
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, env)

      expect(log.string).to include('Creating vm') # ensure .debug logs are included
      expect(log.string).to include('POST')        # ensure HTTP logs are included
      expect(log.string).to include('redacted')    # ensure password is redacted

      if log.string.include?(password)
        fail 'Expected CPI log to not contain the contents of $BOSH_VSPHERE_CPI_PASSWORD but it did.'
      end
      expect(log.string).to_not include('my-fake-secret')
    end
  end

  context 'when http_logging is NOT enabled' do
    let(:cpi) do
      opts = cpi_options({ soap_log: log, http_logging: false})
      cpi = VSphereCloud::Cloud.new(opts)
      cpi
    end

    it 'does not log http requests' do
      env = {'secret' => 'my-fake-secret'}
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, env)

      expect(log.string).to include("Creating vm") # ensure .debug logs are included
      expect(log.string).to_not include("POST")        # ensure HTTP logs are included

      if log.string.include?(password)
        fail 'Expected CPI log to not contain the contents of $BOSH_VSPHERE_CPI_PASSWORD but it did.'
      end
      expect(log.string).to_not include('my-fake-secret')
    end
  end

  context 'when request_id is present in the context' do
    let(:cpi) do
      opts = cpi_options({ soap_log: log, http_logging: false, request_id: 'fake-id-1234' })
      cpi = VSphereCloud::Cloud.new(opts)
      cpi
    end
    let(:env) { {'secret' => 'my-fake-secret'} }

    it 'logs request_id' do
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, env)
      expect(log.string).to include('req_id fake-id-1234')
    end
  end

  context 'when request_id is NOT present in the context' do
    let(:cpi) do
      opts = cpi_options({ soap_log: log, http_logging: false })
      cpi = VSphereCloud::Cloud.new(opts)
      cpi
    end
    let(:env) { {'secret' => 'my-fake-secret'} }

    it 'logs request_id' do
      vm_lifecycle(cpi, [], vm_type, network_spec, @stemcell_id, env)
      expect(log.string).to_not include('req_id fake-id-1234')
    end
  end
end
