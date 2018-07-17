require 'spec_helper'


module NSXT
  describe HttpApiClient, fake_logger: true do

    describe 'delete' do
      it 'does' do
        configuration = NSXT::Configuration.new
        configuration.host = 'nsxtm.vcpi-nimbus.local'
        configuration.username = 'admin'
        configuration.password = 'Admin!23Admin'
        #configuration.client_side_validation = false
        if ENV['BOSH_NSXT_CA_CERT_FILE']
          configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
        end
        if ENV['NSXT_SKIP_SSL_VERIFY']
          configuration.verify_ssl = false
        end

        client = NSXT::HttpApiClient.new(configuration)

        opts = {}
        opts[:return_type] = 'IpBlock'
        opts[:body] ='{"cidr":"192.168.168.0/20"}'

        ip_block, code, headers = client.call_api(:POST, "/pools/ip-blocks", opts)
        expect(code).to eq(201)
        expect(ip_block.cidr).to eq("192.168.168.0/20")

        opts = {}
        ip_block, code, headers = client.call_api(:DELETE, "/pools/ip-blocks/#{ip_block.id}", opts)
        expect(code).to eq(200)
      end
    end

    describe 'put' do
      it 'does' do
        configuration = NSXT::Configuration.new
        configuration.host = 'nsxtm.vcpi-nimbus.local'
        configuration.username = 'admin'
        configuration.password = 'Admin!23Admin'
        #configuration.client_side_validation = false
        if ENV['BOSH_NSXT_CA_CERT_FILE']
          configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
        end
        configuration.verify_ssl = false

        client = NSXT::HttpApiClient.new(configuration)

        opts = {}
        opts[:return_type] = 'IpBlock'
        ip_block, code, headers = client.call_api(:GET, "/pools/ip-blocks/e517fab6-3156-48fe-9075-ad7f9ecf7b8d", opts)
        # expect(ip_block.cidr).to eq("192.168.200.0/20")

        ip_block.cidr = "192.168.169.0/20"
        opts[:body] = client.object_to_http_body(ip_block)

        header_params = {}
        header_params['Accept'] = client.select_header_accept(['application/json'])
        header_params['Content-Type'] = client.select_header_content_type(['application/json'])
        opts[:header_params] = header_params
        ip_block, code, headers =
            client.call_api(:put, "/pools/ip-blocks/e517fab6-3156-48fe-9075-ad7f9ecf7b8d", opts)
        expect(code).to eq(200)
        expect(ip_block.cidr).to eq("192.168.169.0/20")
      end
    end

    describe 'post' do
      it 'does' do
        configuration = NSXT::Configuration.new
        configuration.host = 'nsxtm.vcpi-nimbus.local'
        configuration.username = 'admin'
        configuration.password = 'Admin!23Admin'
        #configuration.client_side_validation = false
        if ENV['BOSH_NSXT_CA_CERT_FILE']
          configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
        end
          configuration.verify_ssl = false

        client = NSXT::HttpApiClient.new(configuration)
        opts = {}
        opts[:return_type] = 'IpBlock'
        opts[:body] ='{"cidr":"192.168.168.0/20"}'

        data, code, headers =
            client.call_api(:POST, "/pools/ip-blocks", opts)
        expect(data.cidr).to eq("192.168.168.0/20")
        puts data
      end
    end

    describe 'get' do
      it 'does' do
        configuration = NSXT::Configuration.new
        configuration.host = 'nsxtm.vcpi-nimbus.local'
        configuration.username = 'admin'
        configuration.password = 'Admin!23Admin'
        #configuration.client_side_validation = false
        configuration.ssl_ca_cert = '/tmp/cert/server2.crt'
        configuration.verify_ssl = true

        client = NSXT::HttpApiClient.new(configuration)
        opts = {}
        opts[:return_type] = 'LogicalRouter'
        data, code, headers = client.call_api(:GET, "/logical-routers/7d15e7fa-2ca8-46ac-aad8-5316c69308e3", opts)
        expect(code).to eq(200)
        expect(data.display_name).to eq('tier-0-router')
        puts data
      end
    end
  end
end