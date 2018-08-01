require 'cloud/vsphere/logger'

module VSphereCloud
  module SdkHelpers
    class RetryableStubAdapter
      include Logger

      PC = VimSdk::Vmodl::Query::PropertyCollector

      def initialize(stub_adapter, retry_judge=nil, retryer=nil)
        @stub_adapter = stub_adapter
        @retry_judge = retry_judge || RetryJudge.new
        @retryer = retryer || Retryer.new
      end


      SILENT_RUN_METHOD = Set[
        'QueryOptions',
        'UpdateOptions',
        'RetrievePropertiesEx',
        'RetrieveProperties',
        'HttpNfcLeaseProgress',
        'CurrentTime'
      ]

      SILENT_ERROR_METHOD = Set[
        'QueryOptions',
        'UpdateOptions',
      ]

      def invoke_method(managed_object, method_info, arguments)
        method_name = method_info.wsdl_name
        method_result = @retryer.try do |i|
          result = nil
          err = nil

          unless SILENT_RUN_METHOD.include?(method_name)
            if i == 0
              logger.debug("Running method '#{method_name}'...")
            else
              logger.warn("Retrying method '#{method_name}', #{i} attempts so far...")
            end
          end

          begin
            status, object = @stub_adapter.invoke_method(managed_object, method_info, arguments, self)
          rescue URI::Error,
            SocketError,
            Errno::ECONNREFUSED,
            Errno::ETIMEDOUT,
            Errno::ECONNRESET,
            Timeout::Error,
            HTTPClient::TimeoutError,
            HTTPClient::KeepAliveDisconnected,
            OpenSSL::SSL::SSLError,
            OpenSSL::X509::StoreError => e
            unless SILENT_ERROR_METHOD.include?(method_name)
              logger.warn("Error running method '#{method_name}'. Failed with '#{e.class}: #{e.message}'")
            end
            err = e
          else
            if status.between?(200, 299)
              result = object
            elsif object.kind_of?(VimSdk::Vmodl::MethodFault)
              err = VimSdk::SoapError.new(object.msg, object)
            else
              err = VimSdk::SoapError.new('Unknown SOAP fault', object)
            end

            if err
              unless SILENT_ERROR_METHOD.include?(method_name)
                logger.warn(fault_message(method_name, err))
              end
              unless @retry_judge.retryable?(managed_object, method_info.wsdl_name, object)
                raise err
              end
            end
          end
          [result, err]
        end
        method_result
      end

      def invoke_property(managed_object, property_info)
        @stub_adapter.invoke_property(managed_object, property_info, self)
      end

      def version
        @stub_adapter.version
      end

      def vc_cookie
        @stub_adapter.vc_cookie
      end

      private

      def fault_message(method_name, err)
        msg = "Error running method '#{method_name}'. Failed with message '#{err.message}'"
        if err.fault && err.fault.fault_cause
          msg += " and cause '#{err.fault.fault_cause}'"
        end
        msg << '.'
        msg
      end
    end
  end
end
