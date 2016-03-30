require 'spec_helper'

module VSphereCloud
  describe CpiHttpClient do
    subject(:http_client) { CpiHttpClient.build }

    describe '.build' do
      after do
        ENV.delete("BOSH_CA_CERT_FILE")
      end

      it 'creates an HTTPClient with specific options' do
        expect(http_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(http_client.send_timeout).to eq(14400)
        expect(http_client.receive_timeout).to eq(14400)
        expect(http_client.connect_timeout).to eq(30)
      end

      it 'configures SSL when BOSH_CA_CERT_FILE has been set in the environment' do
        cert = Tempfile.open('ca-cert') do |f|
          f.write strip_heredoc %(
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

        ENV["BOSH_CA_CERT_FILE"] = cert.path
        expect(http_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT)
        expect(http_client.ssl_config.cert_store_items).to include(cert.path)
      end
    end
  end
end
