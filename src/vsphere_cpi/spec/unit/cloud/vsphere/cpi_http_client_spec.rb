require 'spec_helper'

module VSphereCloud
  describe CpiHttpClient do
    describe '.build' do
      it 'creates an HTTPClient with specific options' do
        http_client = CpiHttpClient.build

        expect(http_client.ssl_config.verify_mode).to eq(OpenSSL::SSL::VERIFY_NONE)
        expect(http_client.send_timeout).to eq(14400)
        expect(http_client.receive_timeout).to eq(14400)
        expect(http_client.connect_timeout).to eq(30)
      end
    end
  end
end
