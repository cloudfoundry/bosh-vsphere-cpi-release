require 'openssl'

# TLS truncation mitigation setting:
#  - https://www.openssl.org/docs/man3.0/man3/SSL_CTX_set_options.html#SSL_OP_IGNORE_UNEXPECTED_EOF
# OpenSSL SSLContext patching recommendation:
#  - https://www.ruby-lang.org/en/news/2014/10/27/changing-default-settings-of-ext-openssl/

if defined?(OpenSSL::SSL::OP_IGNORE_UNEXPECTED_EOF)
  # This is required for vCenter 6.7 and earlier when OpenSSL v3 is used
  def disable_tls_truncation_attack_mitigation(ssl_context_options)
    ssl_context_options[:options] |= OpenSSL::SSL::OP_IGNORE_UNEXPECTED_EOF
    ssl_context_options
  end

  module OpenSSL
    module SSL
      class SSLContext
        original_default_params = remove_const(:DEFAULT_PARAMS)

        const_set(
          :DEFAULT_PARAMS,
          disable_tls_truncation_attack_mitigation(original_default_params)
        )
      end
    end
  end
end
