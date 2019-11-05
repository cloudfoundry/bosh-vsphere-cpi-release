require 'integration/spec_helper'
require 'openssl'

describe 'NSXT certificate authentication', :nsxt_21 => true do

  before(:all) do
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    configuration = NSXT::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    configuration.password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false
    client = NSXT::ApiClient.new(configuration)
    @nsx_component_api = NSXT::NsxComponentAdministrationApi.new(client)
  end

  let(:client) { create_client_cert_auth_client(@private_key, @certificate) }
  let(:nsx_component_api) { NSXT::NsxComponentAdministrationApi.new(client) }

  context 'when certificate is attached to principal' do
    before do
      @private_key = generate_private_key
      @certificate = generate_certificate(@private_key)
      @cert_id = submit_cert_to_nsxt(@certificate)
      @principal_id = attach_cert_to_principal(@cert_id)
    end

    after do
      delete_principal(@principal_id) unless @principal_id.nil?
      delete_test_certificate(@cert_id) unless @cert_id.nil?
    end

    it 'used to authenticate a client' do
      #NSXT needs some time to make cert available for cert auth
      sleep(30)
      certs = nsx_component_api.get_certificates
      expect(certs).not_to be_nil
    end

    context 'when another principal exists' do
      let(:client2) { create_client_cert_auth_client(@private_key2, @certificate2) }
      let(:nsx_component_api2) { NSXT::NsxComponentAdministrationApi.new(client2) }

      let(:router_api) { NSXT::LogicalRoutingAndServicesApi.new(client) }
      let(:router_api2) { NSXT::LogicalRoutingAndServicesApi.new(client2) }

      before do
        @private_key2 = generate_private_key
        @certificate2 = generate_certificate(@private_key2)
        @cert2_id = submit_cert_to_nsxt(@certificate2)
        @principal2_id = attach_cert_to_principal(@cert2_id, 'testprincipal2', 'node-2')
      end

      after do
        router_api.delete_logical_router(@router_id) unless @router_id.nil?
        delete_principal(@principal2_id) unless @principal2_id.nil?
        delete_test_certificate(@cert2_id) unless @cert2_id.nil?
      end

      it 'can change other principal data' do
        #NSXT needs some time to make cert available for cert auth
        sleep(30)

        router = NSXT::LogicalRouter.new(router_type: 'TIER1')
        router = router_api.create_logical_router(router)
        @router_id = router.id
        expect(@router_id).not_to be_nil

        router = router_api2.read_logical_router(@router_id)
        expect(router._protection).to eq('REQUIRE_OVERRIDE')
        router.display_name = 'new-name';

        router = router_api2.update_logical_router(@router_id, router)
        expect(router.display_name).to eq('new-name')
      end
    end
  end

  context 'if certificate is not attach to principal' do
    before do
      @private_key = generate_private_key
      @certificate = generate_certificate(@private_key)
      @cert_id = submit_cert_to_nsxt(@certificate)
    end

    after do
      delete_test_certificate(@cert_id) unless @cert_id.nil?
    end

    it 'returns auth exception' do
      expect {
        #NSXT needs some time to make cert available for cert auth
        sleep(30)
        nsx_component_api.get_certificates
      }.to raise_error(/SSL connect error/)
    end
  end

  def submit_cert_to_nsxt(certificate)
    trust_object = NSXT::TrustObjectData.new(pem_encoded: certificate)
    certs = @nsx_component_api.add_certificate_import(trust_object)
    certs.results[0].id
  end

  def delete_test_certificate(cert_id)
    @nsx_component_api.delete_certificate(cert_id)
  end

  def attach_cert_to_principal(cert_id, pi_name = 'testprincipal-3', node_id = 'node-5')
    pi = NSXT::PrincipalIdentity.new(name: pi_name, node_id: node_id,
                                     certificate_id: cert_id, permission_group: 'superusers')
    @nsx_component_api.register_principal_identity(pi).id
  end

  def delete_principal(principal_id)
    @nsx_component_api.delete_principal_identity(principal_id)
  end

  def generate_private_key
    OpenSSL::PKey::RSA.new(2048)
  end

  def generate_certificate(private_key)
    subject = '/CN=bosh-test-user'
    cert = OpenSSL::X509::Certificate.new
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = Time.now
    cert.not_after = Time.now + 365 * 24 * 60 * 60
    cert.public_key = private_key.public_key
    cert.serial = 0x0
    cert.version = 1
    cert.sign(private_key, OpenSSL::Digest::SHA256.new)
    cert
  end

  def create_client_cert_auth_client(private_key, certificate)
    tempfile = Tempfile.new('bosh-test.key')
    tempfile.write(private_key)
    tempfile.close
    private_key_file = tempfile.path

    tempfile = Tempfile.new('bosh-test.crt')
    tempfile.write(certificate)
    tempfile.close
    cert_file = tempfile.path

    configuration = NSXT::Configuration.new
    configuration.host = @nsxt_host
    configuration.key_file  = private_key_file
    configuration.cert_file = cert_file
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false

    NSXT::ApiClient.new(configuration)
  end
end