require 'rack'
require 'thin'

module Support
  module StringHelpers
    class << self
      def strip_heredoc(string)
        indent = (string.scan(/^[ \t]*(?=\S)/).min || '').size || 0
        string.gsub(/^[ \t]{#{indent}}/, '')
      end
    end
  end

  def certificate(mode)
    case mode
    when :failure
      Tempfile.open('ca-cert') do |f|
        f.write StringHelpers.strip_heredoc %(
          -----BEGIN CERTIFICATE-----
          MIID0DCCArigAwIBAgIBADANBgkqhkiG9w0BAQUFADA8MQswCQYDVQQGDAJKUDES
          MBAGA1UECgwJSklOLkdSLkpQMQwwCgYDVQQLDANSUlIxCzAJBgNVBAMMAkNBMB4X
          DTA0MDEzMDAwNDIzMloXDTM2MDEyMjAwNDIzMlowPDELMAkGA1UEBgwCSlAxEjAQ
          BgNVBAoMCUpJTi5HUi5KUDEMMAoGA1UECwwDUlJSMQswCQYDVQQDDAJDQTCCASIw
          DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANbv0x42BTKFEQOE+KJ2XmiSdZpR
          wjzQLAkPLRnLB98tlzs4xo+y4RyY/rd5TT9UzBJTIhP8CJi5GbS1oXEerQXB3P0d
          L5oSSMwGGyuIzgZe5+vZ1kgzQxMEKMMKlzA73rbMd4Jx3u5+jdbP0EDrPYfXSvLY
          bS04n2aX7zrN3x5KdDrNBfwBio2/qeaaj4+9OxnwRvYP3WOvqdW0h329eMfHw0pi
          JI0drIVdsEqClUV4pebT/F+CPUPkEh/weySgo9wANockkYu5ujw2GbLFcO5LXxxm
          dEfcVr3r6t6zOA4bJwL0W/e6LBcrwiG/qPDFErhwtgTLYf6Er67SzLyA66UCAwEA
          AaOB3DCB2TAPBgNVHRMBAf8EBTADAQH/MDEGCWCGSAGG+EIBDQQkFiJSdWJ5L09w
          ZW5TU0wgR2VuZXJhdGVkIENlcnRpZmljYXRlMB0GA1UdDgQWBBRJ7Xd380KzBV7f
          USKIQ+O/vKbhDzAOBgNVHQ8BAf8EBAMCAQYwZAYDVR0jBF0wW4AUSe13d/NCswVe
          31EiiEPjv7ym4Q+hQKQ+MDwxCzAJBgNVBAYMAkpQMRIwEAYDVQQKDAlKSU4uR1Iu
          SlAxDDAKBgNVBAsMA1JSUjELMAkGA1UEAwwCQ0GCAQAwDQYJKoZIhvcNAQEFBQAD
          ggEBAIu/mfiez5XN5tn2jScgShPgHEFJBR0BTJBZF6xCk0jyqNx/g9HMj2ELCuK+
          r/Y7KFW5c5M3AQ+xWW0ZSc4kvzyTcV7yTVIwj2jZ9ddYMN3nupZFgBK1GB4Y05GY
          MJJFRkSu6d/Ph5ypzBVw2YMT/nsOo5VwMUGLgS7YVjU+u/HNWz80J3oO17mNZllj
          PvORJcnjwlroDnS58KoJ7GDgejv3ESWADvX1OHLE4cRkiQGeLoEU4pxdCxXRqX0U
          PbwIkZN9mXVcrmPHq8MWi4eC/V7hnbZETMHuWhUoiNdOEfsAXr3iP4KjyyRdwc7a
          d/xgcK06UVQRL/HbEYGiQL056mc=
          -----END CERTIFICATE-----
        )

        f
      end
    when :success
      Tempfile.open('ca-cert') do |f|
        f.write StringHelpers.strip_heredoc %(
          -----BEGIN CERTIFICATE-----
          MIID0DCCArigAwIBAgIBADANBgkqhkiG9w0BAQUFADA8MQswCQYDVQQGDAJKUDES
          MBAGA1UECgwJSklOLkdSLkpQMQwwCgYDVQQLDANSUlIxCzAJBgNVBAMMAkNBMB4X
          DTA0MDEzMDAwNDIzMloXDTM2MDEyMjAwNDIzMlowPDELMAkGA1UEBgwCSlAxEjAQ
          BgNVBAoMCUpJTi5HUi5KUDEMMAoGA1UECwwDUlJSMQswCQYDVQQDDAJDQTCCASIw
          DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANbv0x42BTKFEQOE+KJ2XmiSdZpR
          wjzQLAkPLRnLB98tlzs4xo+y4RyY/rd5TT9UzBJTIhP8CJi5GbS1oXEerQXB3P0d
          L5oSSMwGGyuIzgZe5+vZ1kgzQxMEKMMKlzA73rbMd4Jx3u5+jdbP0EDrPYfXSvLY
          bS04n2aX7zrN3x5KdDrNBfwBio2/qeaaj4+9OxnwRvYP3WOvqdW0h329eMfHw0pi
          JI0drIVdsEqClUV4pebT/F+CPUPkEh/weySgo9wANockkYu5ujw2GbLFcO5LXxxm
          dEfcVr3r6t6zOA4bJwL0W/e6LBcrwiG/qPDFErhwtgTLYf6Er67SzLyA66UCAwEA
          AaOB3DCB2TAPBgNVHRMBAf8EBTADAQH/MDEGCWCGSAGG+EIBDQQkFiJSdWJ5L09w
          ZW5TU0wgR2VuZXJhdGVkIENlcnRpZmljYXRlMB0GA1UdDgQWBBRJ7Xd380KzBV7f
          USKIQ+O/vKbhDzAOBgNVHQ8BAf8EBAMCAQYwZAYDVR0jBF0wW4AUSe13d/NCswVe
          31EiiEPjv7ym4Q+hQKQ+MDwxCzAJBgNVBAYMAkpQMRIwEAYDVQQKDAlKSU4uR1Iu
          SlAxDDAKBgNVBAsMA1JSUjELMAkGA1UEAwwCQ0GCAQAwDQYJKoZIhvcNAQEFBQAD
          ggEBAIu/mfiez5XN5tn2jScgShPgHEFJBR0BTJBZF6xCk0jyqNx/g9HMj2ELCuK+
          r/Y7KFW5c5M3AQ+xWW0ZSc4kvzyTcV7yTVIwj2jZ9ddYMN3nupZFgBK1GB4Y05GY
          MJJFRkSu6d/Ph5ypzBVw2YMT/nsOo5VwMUGLgS7YVjU+u/HNWz80J3oO17mNZllj
          PvORJcnjwlroDnS58KoJ7GDgejv3ESWADvX1OHLE4cRkiQGeLoEU4pxdCxXRqX0U
          PbwIkZN9mXVcrmPHq8MWi4eC/V7hnbZETMHuWhUoiNdOEfsAXr3iP4KjyyRdwc7a
          d/xgcK06UVQRL/HbEYGiQL056mc=
          -----END CERTIFICATE-----
          -----BEGIN CERTIFICATE-----
          MIIDaDCCAlCgAwIBAgIBATANBgkqhkiG9w0BAQUFADA8MQswCQYDVQQGDAJKUDES
          MBAGA1UECgwJSklOLkdSLkpQMQwwCgYDVQQLDANSUlIxCzAJBgNVBAMMAkNBMB4X
          DTA0MDEzMDAwNDMyN1oXDTM1MDEyMjAwNDMyN1owPzELMAkGA1UEBgwCSlAxEjAQ
          BgNVBAoMCUpJTi5HUi5KUDEMMAoGA1UECwwDUlJSMQ4wDAYDVQQDDAVTdWJDQTCC
          ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ0Ou7AyRcRXnB/kVHv/6kwe
          ANzgg/DyJfsAUqW90m7Lu1nqyug8gK0RBd77yU0w5HOAMHTVSdpjZK0g2sgx4Mb1
          d/213eL9TTl5MRVEChTvQr8q5DVG/8fxPPE7fMI8eOAzd98/NOAChk+80r4Sx7fC
          kGVEE1bKwY1MrUsUNjOY2d6t3M4HHV3HX1V8ShuKfsHxgCmLzdI8U+5CnQedFgkm
          3e+8tr8IX5RR1wA1Ifw9VadF7OdI/bGMzog/Q8XCLf+WPFjnK7Gcx6JFtzF6Gi4x
          4dp1Xl45JYiVvi9zQ132wu8A1pDHhiNgQviyzbP+UjcB/tsOpzBQF8abYzgEkWEC
          AwEAAaNyMHAwDwYDVR0TAQH/BAUwAwEB/zAxBglghkgBhvhCAQ0EJBYiUnVieS9P
          cGVuU1NMIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQUlCjXWLsReYzH
          LzsxwVnCXmKoB/owCwYDVR0PBAQDAgEGMA0GCSqGSIb3DQEBBQUAA4IBAQCJ/OyN
          rT8Cq2Y+G2yA/L1EMRvvxwFBqxavqaqHl/6rwsIBFlB3zbqGA/0oec6MAVnYynq4
          c4AcHTjx3bQ/S4r2sNTZq0DH4SYbQzIobx/YW8PjQUJt8KQdKMcwwi7arHP7A/Ha
          LKu8eIC2nsUBnP4NhkYSGhbmpJK+PFD0FVtD0ZIRlY/wsnaZNjWWcnWF1/FNuQ4H
          ySjIblqVQkPuzebv3Ror6ZnVDukn96Mg7kP4u6zgxOeqlJGRe1M949SS9Vudjl8X
          SF4aZUUB9pQGhsqQJVqaz2OlhGOp9D0q54xko/rekjAIcuDjl1mdX4F2WRrzpUmZ
          uY/bPeOBYiVsOYVe
          -----END CERTIFICATE-----
        )

        f
      end
    end
  end

  # NOTE: be careful... you only want one.
  def serve_https
    @server = Support::HTTP::Server.new
    @server.run
  end

  module HTTP
    class Server
      attr_reader :app, :host, :port

      def initialize
        @app  = Support::HTTP::Application.new('success')
        @host = '127.0.0.1'
        @port = available_port
      end

      def run
        @thread = Thread.new do
          Rack::Handler::Thin.run(app, { :Host => host, :Port => port }) do |config|
            config.ssl = true
            config.ssl_options = {
              :private_key_file => private_key.path,
              :cert_chain_file => cert_chain.path
            }
          end
        end

        Timeout.timeout(5) { @thread.join(0.1) until responsive? }
        self
      rescue Timeout::Error
        raise "Failed to start #{self.class.name} on port: #{port}"
      end

      private

      def private_key
        Tempfile.open('ca-cert') do |f|
          f.write StringHelpers.strip_heredoc %(
            -----BEGIN RSA PRIVATE KEY-----
            MIICXQIBAAKBgQDRSU8Vqrqd51fXbCQJLqflml5zzSM3KQAN6jBmQyUybH2vA7u2
            cUz9FySuZhE7bQa5+9dXCcQLj9yo6p1vUr7WfZWNrFyemY+trDeS8Bt1VXtuXSNv
            MkdRLGx4yeWY3/bZoIDAumpudncbh27ef7x6OJ4CbihP1PnnhkYrzJ+oBQIDAQAB
            AoGBAIf4CstW2ltQO7+XYGoex7Hh8s9lTSW/G2vu5Hbr1LTHy3fzAvdq8MvVR12O
            rk9fa+lU9vhzPc0NMB0GIDZ9GcHuhW5hD1Wg9OSCbTOkZDoH3CAFqonjh4Qfwv5W
            IPAFn9KHukdqGXkwEMdErsUaPTy9A1V/aROVEaAY+HJgq/eZAkEA/BP1QMV04WEZ
            Oynzz7/lLizJGGxp2AOvEVtqMoycA/Qk+zdKP8ufE0wbmCE3Qd6GoynavsHb6aGK
            gQobb8zDZwJBANSK6MrXlrZTtEaeZuyOB4mAmRzGzOUVkUyULUjEx2GDT93ujAma
            qm/2d3E+wXAkNSeRpjUmlQXy/2oSqnGvYbMCQQDRM+cYyEcGPUVpWpnj0shrF/QU
            9vSot/X1G775EMTyaw6+BtbyNxVgOIu2J+rqGbn3c+b85XqTXOPL0A2RLYkFAkAm
            syhSDtE9X55aoWsCNZY/vi+i4rvaFoQ/WleogVQAeGVpdo7/DK9t9YWoFBIqth0L
            mGSYFu9ZhvZkvQNV8eYrAkBJ+rOIaLDsmbrgkeDruH+B/9yrm4McDtQ/rgnOGYnH
            LjLpLLOrgUxqpzLWe++EwSLwK2//dHO+SPsQJ4xsyQJy
            -----END RSA PRIVATE KEY-----
          )

          f
        end
      end

      def cert_chain
        Tempfile.open('ca-cert') do |f|
          f.write StringHelpers.strip_heredoc %(
            -----BEGIN CERTIFICATE-----
            MIIC/zCCAeegAwIBAgIBATANBgkqhkiG9w0BAQUFADA/MQswCQYDVQQGDAJKUDES
            MBAGA1UECgwJSklOLkdSLkpQMQwwCgYDVQQLDANSUlIxDjAMBgNVBAMMBVN1YkNB
            MB4XDTA0MDEzMTAzMTMxNloXDTMzMDEyMzAzMTMxNlowQzELMAkGA1UEBgwCSlAx
            EjAQBgNVBAoMCUpJTi5HUi5KUDEMMAoGA1UECwwDUlJSMRIwEAYDVQQDDAlsb2Nh
            bGhvc3QwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBANFJTxWqup3nV9dsJAku
            p+WaXnPNIzcpAA3qMGZDJTJsfa8Du7ZxTP0XJK5mETttBrn711cJxAuP3KjqnW9S
            vtZ9lY2sXJ6Zj62sN5LwG3VVe25dI28yR1EsbHjJ5Zjf9tmggMC6am52dxuHbt5/
            vHo4ngJuKE/U+eeGRivMn6gFAgMBAAGjgYUwgYIwDAYDVR0TAQH/BAIwADAxBglg
            hkgBhvhCAQ0EJBYiUnVieS9PcGVuU1NMIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAd
            BgNVHQ4EFgQUpZIyygD9JxFYHHOTEuWOLbCKfckwCwYDVR0PBAQDAgWgMBMGA1Ud
            JQQMMAoGCCsGAQUFBwMBMA0GCSqGSIb3DQEBBQUAA4IBAQBwAIj5SaBHaA5X31IP
            CFCJiep96awfp7RANO0cuUj+ZpGoFn9d6FXY0g+Eg5wAkCNIzZU5NHN9xsdOpnUo
            zIBbyTfQEPrge1CMWMvL6uGaoEXytq84VTitF/xBTky4KtTn6+es4/e7jrrzeUXQ
            RC46gkHObmDT91RkOEGjHLyld2328jo3DIN/VTHIryDeVHDWjY5dENwpwdkhhm60
            DR9IrNBbXWEe9emtguNXeN0iu1ux0lG1Hc6pWGQxMlRKNvGh0yZB9u5EVe38tOV0
            jQaoNyL7qzcQoXD3Dmbi1p0iRmg/+HngISsz8K7k7MBNVsSclztwgCzTZOBiVtkM
            rRlQ
            -----END CERTIFICATE-----
          )

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
        response = Net::HTTP.start(host, port, options) { |http| http.get('/__identify__') }

        if response.is_a?(Net::HTTPSuccess) || response.is_a?(Net::HTTPRedirection)
          return response.body == app.object_id.to_s
        end
      rescue SystemCallError
        return false
      end
    end

    class Application
      def initialize(body = nil)
        @body = body
      end

      def call(env)
        if env['PATH_INFO'] == '/__identify__'
          [200, {}, self.object_id.to_s]
        else
          [200, {}, @body]
        end
      end
    end
  end
end
