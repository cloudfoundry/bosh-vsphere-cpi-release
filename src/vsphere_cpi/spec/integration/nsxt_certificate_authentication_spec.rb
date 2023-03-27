require 'integration/spec_helper'
require 'openssl'
require 'nsxt_manager_client/nsxt_manager_client'
require 'nsxt_policy_client/nsxt_policy_client'

describe 'NSXT certificate authentication', nsxt_all: true do

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
    @nsx_component_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementCertificateApi.new(client)
    @nsx_component_pricipal_id_api = NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementPrincipalIdentityApi.new(client)
    @vsphere_version = fetch_optional_property('BOSH_VSPHERE_VERSION')
  end

  let(:client) { create_client_cert_auth_client(@private_key, @certificate) }
  let(:nsx_component_api) { NSXT::ManagementPlaneApiNsxComponentAdministrationTrustManagementCertificateApi.new(client) }

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

    context 'when another principal exists and x_allow_overwrite is on' do
      let(:client2) { create_client_cert_auth_client(@private_key2, @certificate2, true) }

      let(:router_api) { NSXT::ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.new(client) }
      let(:router_api2) { NSXT::ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.new(client2) }

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

    context 'when another principal exists and x_allow_overwrite is off' do
      let(:client2) { create_client_cert_auth_client(@private_key2, @certificate2, false) }

      let(:router_api) { NSXT::ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.new(client) }
      let(:router_api2) { NSXT::ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.new(client2) }

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

      it 'cannot change other principal data' do
        #NSXT needs some time to make cert available for cert auth
        sleep(30)

        router = NSXT::LogicalRouter.new(router_type: 'TIER1')
        router = router_api.create_logical_router(router)
        @router_id = router.id
        expect(@router_id).not_to be_nil

        router = router_api2.read_logical_router(@router_id)
        expect(router._protection).to eq('REQUIRE_OVERRIDE')
        router.display_name = 'new-name';

        expect {
        router = router_api2.update_logical_router(@router_id, router)
        }.to raise_error(NSXT::ApiCallError)
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
      }.to raise_error(/[Ee]rror/)
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
                                     certificate_id: cert_id, role: 'enterprise_admin')
    @nsx_component_pricipal_id_api.register_principal_identity(pi).id
  end

  def delete_principal(principal_id)
    @nsx_component_pricipal_id_api.delete_principal_identity(principal_id)
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

  def create_client_cert_auth_client(private_key, certificate, x_allow_overwrite = false)
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
    configuration.key_file = private_key_file
    configuration.cert_file = cert_file
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false

    client = NSXT::ApiClient.new(configuration)
    #this is probably more interesting to test via the defaults set in NsxtApiClientBuilder
    #but that is a much larger change. That we default to "true" (as of this comment writing) is implicitly tested
    #by many integration tests.
    if x_allow_overwrite
      client.x_allow_overwrite
    end
    client
  end
end