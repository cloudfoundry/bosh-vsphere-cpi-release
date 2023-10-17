require 'rackup'
require 'webrick'
require 'webrick/https'

module Support
  def self.generate_certificate(name:, is_ca:, ca_certificate: nil, ca_private_key: nil)
    private_key = OpenSSL::PKey::RSA.new(2048)
    certificate = OpenSSL::X509::Certificate.new
    certificate.serial = SecureRandom.random_number(2**(8*20))
    certificate.version = 2
    certificate.public_key = private_key.public_key
    certificate.not_before = Time.now - 24 * 60 * 60
    certificate.not_after = Time.now + 365 * 24 * 60 * 60
    certificate.subject = OpenSSL::X509::Name.parse("/C=US/O=VMware/CN=#{name}")

    # When no CA is passed in, assume self-signed
    ca_certificate ||= certificate
    ca_private_key ||= private_key

    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = certificate
    ef.issuer_certificate = ca_certificate

    certificate.add_extension(ef.create_extension('subjectKeyIdentifier', 'hash', false))
    certificate.add_extension(ef.create_extension('authorityKeyIdentifier', 'keyid:always', false))
    certificate.add_extension(ef.create_extension('extendedKeyUsage', 'clientAuth,serverAuth', false))
    if is_ca
      certificate.add_extension(ef.create_extension('basicConstraints', 'CA:TRUE', true))
      certificate.add_extension(ef.create_extension('keyUsage', 'cRLSign,keyCertSign', true))
    else
      certificate.add_extension(ef.create_extension('keyUsage', 'digitalSignature', true))
    end
    certificate.add_extension(ef.create_extension('subjectAltName', "DNS:#{name}", false))

    certificate.issuer = ca_certificate.subject
    certificate.sign(ca_private_key, OpenSSL::Digest::SHA256.new)

    { certificate: certificate, private_key: private_key }
  end

  def self.unrelated_ca
    @unrelated_ca ||= generate_certificate(name: 'UnrelatedCA', is_ca: true)
  end

  def self.signing_ca
    @signing_ca ||= generate_certificate(name: 'SigningCA', is_ca: true)
  end

  def self.leaf_certificate
    @leaf_certificate ||= generate_certificate(name: 'localhost', is_ca: false, ca_certificate: signing_ca[:certificate], ca_private_key: signing_ca[:private_key])
  end

  def certificate(mode)
    case mode
    when :failure
      Tempfile.open('ca-cert') do |f|
        f.write Support.unrelated_ca[:certificate].to_pem

        f
      end
    when :success
      Tempfile.open('ca-cert') do |f|
        f.write "#{Support.unrelated_ca[:certificate].to_pem}\n#{Support.signing_ca[:certificate].to_pem}"

        f
      end
    end
  end

  # NOTE: be careful... you only want one.
  def serve_https
    @server = Support::HTTP::Server.new
    @server.run
  end

  def stop_server
    @server.shutdown
  end

  module HTTP
    class Server
      attr_reader :host, :port

      def initialize
        @host = '127.0.0.1'
        @port = available_port
      end

      def run
        path_to_binary_file = File.join(File.dirname(__FILE__), 'fixtures', 'env.iso')

        @thread = Thread.new do
          server_config = {
            Host: host,
            Port: port,
            Logger: WEBrick::Log.new(File.open(File::NULL, 'w')),
            AccessLog: [],
            SSLEnable: true,
            SSLVerifyClient: OpenSSL::SSL::VERIFY_NONE,
            SSLPrivateKey: OpenSSL::PKey::RSA.new(File.open(private_key.path).read),
            SSLCertificate: OpenSSL::X509::Certificate.new(File.open(cert_chain.path).read),
          }

          Rack::Handler::WEBrick.run(Rack::Builder.new {
            map '/download' do
              run lambda { |env|
                response = Rack::Response.new
                response.headers.merge!('Content-Type' => 'application/octet-stream')
                File.open(path_to_binary_file, 'rb') { |file| response.write(file) }
                response.finish
              }
            end

            map '/download-text' do
              run lambda { |env|
                response = Rack::Response.new
                response.headers.merge!('Content-Type' => 'application/octet-stream')
                response.write('{ "some-key": "some-value" }')
                response.finish
              }
            end

            run lambda { |env| [200, { 'Content-Type' => 'text/plain'}, ['success']] }
          }, **server_config)
        end

        Timeout.timeout(5) { @thread.join(0.1) until responsive? }
        self
      rescue Timeout::Error
        raise "Failed to start #{self.class.name} on port: #{port}"
      end

      def shutdown
        @thread.exit
      end

      private

      def private_key
        Tempfile.open('ca-cert') do |f|
          f.write Support.leaf_certificate[:private_key].to_pem

          f
        end
      end

      def cert_chain
        Tempfile.open('ca-cert') do |f|
          f.write Support.leaf_certificate[:certificate].to_pem

          f
        end
      end

      def available_port
        server = TCPServer.new('localhost', 0)
        server.addr[1]
      ensure
        server.close if server
      end

      def responsive?
        return false if @thread && @thread.join(0)
        options = { :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE }
        response = Net::HTTP.start(host, port, options) { |http| http.get('/') }

        if response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
          return response.code == '200'
        end
      rescue SystemCallError
        return false
      end
    end
  end
end
