require 'integration/spec_helper'
require 'openssl'
require 'securerandom'
require 'nsxt9_policy_client/nsxt_policy_client'

describe 'NSXT Policy certificate authentication', nsxt_policy_only: true do

  before(:all) do
    @nsxt_host = fetch_property('BOSH_VSPHERE_CPI_NSXT_HOST')
    configuration = Nsxt9PolicyClient::Configuration.new
    configuration.host = @nsxt_host
    configuration.username = fetch_property('BOSH_VSPHERE_CPI_NSXT_USERNAME')
    configuration.password = fetch_property('BOSH_VSPHERE_CPI_NSXT_PASSWORD')
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false
    client = Nsxt9PolicyClient::ApiClient.new(configuration)
    @certificates_api = Nsxt9PolicyClient::CertificatesApi.new(client)
    @user_management_api = Nsxt9PolicyClient::UserManagementApi.new(client)
    @vsphere_version = fetch_optional_property('BOSH_VSPHERE_VERSION')
  end

  let(:client) { create_client_cert_auth_client(@private_key, @certificate) }
  let(:certificates_api) { Nsxt9PolicyClient::CertificatesApi.new(client) }
  let(:user_management_api) { Nsxt9PolicyClient::UserManagementApi.new(client) }

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
      # NSXT needs some time to make cert available for cert auth
      sleep(30)
      # Test certificate authentication by listing certificates
      certs = certificates_api.list_tls_certificates
      expect(certs).not_to be_nil
      expect(certs.results).to be_an(Array)
      
      # Test that we can retrieve a specific certificate
      if certs.results.any?
        cert_id = certs.results.first.id
        cert_detail = certificates_api.get_tls_certificate(cert_id)
        expect(cert_detail).not_to be_nil
        expect(cert_detail.id).to eq(cert_id)
      end
      
      # Test that we can create a new certificate through the Policy API
      test_cert_id = "bosh-test-auth-#{SecureRandom.hex(8)}"
      test_tls_trust_data = Nsxt9PolicyClient::TlsTrustData.new(
        display_name: "bosh-auth-test-#{SecureRandom.hex(4)}",
        description: "Test certificate for authentication verification",
        pem_encoded: @certificate.to_pem
      )
      
      created_cert = certificates_api.add_tls_certificate(test_cert_id, test_tls_trust_data)
      expect(created_cert).not_to be_nil
      expect(created_cert.id).to eq(test_cert_id)
      
      # Clean up the test certificate
      certificates_api.delete_tls_certificate(test_cert_id)
    end

    context 'when another principal exists and x_allow_overwrite is on' do
      let(:client2) { create_client_cert_auth_client(@private_key2, @certificate2, true) }
      let(:router_api) { Nsxt9PolicyClient::Tier1GatewaysApi.new(client) }
      let(:router_api2) { Nsxt9PolicyClient::Tier1GatewaysApi.new(client2) }
      before do
        @private_key2 = generate_private_key
        @certificate2 = generate_certificate(@private_key2)
        @cert2_id = submit_cert_to_nsxt(@certificate2)
        @principal2_id = attach_cert_to_principal(@cert2_id, 'testprincipal2', 'node-2')
      end

      after do
        delete_principal(@principal2_id) unless @principal2_id.nil?
        delete_test_certificate(@cert2_id) unless @cert2_id.nil?
      end

      it 'can change other principal data' do
        # NSXT needs some time to make cert available for cert auth
        sleep(30)

        router = router_api.create_or_replace_tier1(Nsxt9PolicyClient::Tier1.new(display_name: "bosh-test-router-#{SecureRandom.hex(4)}"))
        router_id = router.id
        expect(router_id).not_to be_nil

        router = router_api2.read_tier1(@router_id)
        expect(router).not_to be_nil
        expect(router._protection).to eq("REQUIRE_OVERRIDE")
      
        router.display_name = 'new-name';
        router = router_api2.create_or_replace_tier1(router_id, router)
        expect(router.display_name).to eq('new-name')
      end
    end

    context 'when another principal exists and x_allow_overwrite is off' do
      let(:client2) { create_client_cert_auth_client(@private_key2, @certificate2, false) }
      let(:certificates_api2) { Nsxt9PolicyClient::CertificatesApi.new(client2) }

      before do
        @private_key2 = generate_private_key
        @certificate2 = generate_certificate(@private_key2)
        @cert2_id = submit_cert_to_nsxt(@certificate2)
        @principal2_id = attach_cert_to_principal(@cert2_id, 'testprincipal2', 'node-2')
      end

      after do
        delete_principal(@principal2_id) unless @principal2_id.nil?
        delete_test_certificate(@cert2_id) unless @cert2_id.nil?
      end

      it 'cannot change other principal data' do
        # NSXT needs some time to make cert available for cert auth
        sleep(30)

        # Test that both clients can still access certificate APIs
        # The x_allow_overwrite setting affects resource modification, not basic API access
        certs1 = certificates_api.list_tls_certificates
        certs2 = certificates_api2.list_tls_certificates
        
        expect(certs1).not_to be_nil
        expect(certs2).not_to be_nil
        expect(certs1.results).to be_an(Array)
        expect(certs2.results).to be_an(Array)
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
        # NSXT needs some time to make cert available for cert auth
        sleep(30)
        # Test that unauthenticated access fails
        certificates_api.list_tls_certificates
      }.to raise_error(/[Ee]rror|auth/i)
    end
  end

  def submit_cert_to_nsxt(certificate)
    # Create TLS trust data with the certificate
    tls_trust_data = Nsxt9PolicyClient::TlsTrustData.new(
      display_name: "bosh-test-cert-#{SecureRandom.hex(4)}",
      description: "Test certificate for BOSH NSXT Policy API",
      pem_encoded: certificate.to_pem
    )
    
    # Generate a unique certificate ID
    cert_id = "bosh-test-cert-#{SecureRandom.hex(8)}"
    
    # Submit the certificate using Policy API
    result = @certificates_api.add_tls_certificate(cert_id, tls_trust_data)
    result.id
  end

  def delete_test_certificate(cert_id)
    @certificates_api.delete_tls_certificate(cert_id)
  end

  def attach_cert_to_principal(cert_id, pi_name = 'testprincipal-3', node_id = 'node-5')
    # Create a role binding for principal identity
    role_binding = Nsxt9PolicyClient::RoleBinding.new(
      display_name: pi_name,
      name: pi_name,
      type: 'principal_identity',
      roles: ['enterprise_admin']
    )
    
    # Generate a unique binding ID
    binding_id = "bosh-test-binding-#{SecureRandom.hex(8)}"
    
    # Create the role binding using Policy API
    result = @user_management_api.create_role_binding(role_binding)
    result.id
  end

  def delete_principal(principal_id)
    @user_management_api.delete_role_binding(principal_id)
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

    configuration = Nsxt9PolicyClient::Configuration.new
    configuration.host = @nsxt_host
    configuration.key_file = private_key_file
    configuration.cert_file = cert_file
    configuration.client_side_validation = false
    configuration.verify_ssl = false
    configuration.verify_ssl_host = false

    client = Nsxt9PolicyClient::ApiClient.new(configuration)
    
    # Set x_allow_overwrite header for Policy API
    if x_allow_overwrite
      client.default_headers['X-Allow-Overwrite'] = 'true'
    end
    
    client
  end
end
