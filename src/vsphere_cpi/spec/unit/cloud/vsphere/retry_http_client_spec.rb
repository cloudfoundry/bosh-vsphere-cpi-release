require 'spec_helper'

module VSphereCloud
  describe RetryHttpClient do
    let(:http_client) { instance_double(CpiHttpClient) }
    let(:logger) { Logger.new(StringIO.new) }
    subject(:retry_client) { RetryHttpClient.new(http_client, logger) }

    before do
      allow_any_instance_of(Object).to receive(:sleep)
    end

    context 'when HTTP client receives a 200 response' do
      let(:get_response) { double(code: 200, body: nil) }
      let(:post_response) { double(code: 201, body: nil) }
      let(:put_response) { double(code: 202, body: nil) }

      it 'performs a single request' do
        allow(http_client).to receive(:get).once.with("http://example.com", {}).and_return(get_response)
        expect(retry_client.get("http://example.com")).to eq(get_response)

        allow(http_client).to receive(:post).once.with("http://example.com", "fake-content", {}).and_return(post_response)
        expect(retry_client.post("http://example.com", "fake-content")).to eq(post_response)

        allow(http_client).to receive(:put).once.with("http://example.com", "fake-content", {}).and_return(put_response)
        expect(retry_client.put("http://example.com", "fake-content")).to eq(put_response)
      end
    end

    context 'when HTTP client receives a non-retryable response' do
      let(:get_response) { double(code: 401, body: nil) }
      let(:post_response) { double(code: 500, body: nil) }
      let(:put_response) { double(code: 503, body: 'A fake error occurred') }

      it 'performs a single request and returns the unhappy response' do
        expect(http_client).to receive(:get).once.with("http://example.com", {}).and_return(get_response)
        expect(retry_client.get("http://example.com")).to eq(get_response)

        allow(http_client).to receive(:post).once.with("http://example.com", "fake-content", {}).and_return(post_response)
        expect(retry_client.post("http://example.com", "fake-content")).to eq(post_response)

        allow(http_client).to receive(:put).once.with("http://example.com", "fake-content", {}).and_return(put_response)
        expect(retry_client.put("http://example.com", "fake-content")).to eq(put_response)
      end
    end

    context 'when HTTP client receives a retriable response' do
      let(:get_response) { double(code: 500, body: 'An error occurred while communicating with the remote host') }
      let(:post_response) { double(code: 501, body: 'No route to host') }
      let(:put_response) { double(code: 502, body: 'The operation is not allowed in the current state of the host') }

      it 'retries the request' do
        allow(http_client).to receive(:get).exactly(5).times.with("http://example.com", {}).and_return(get_response)
        expect(retry_client.get("http://example.com")).to eq(get_response)

        allow(http_client).to receive(:post).exactly(5).times.with("http://example.com", "fake-content", {}).and_return(post_response)
        expect(retry_client.post("http://example.com", "fake-content")).to eq(post_response)

        allow(http_client).to receive(:put).exactly(5).times.with("http://example.com", "fake-content", {}).and_return(put_response)
        expect(retry_client.put("http://example.com", "fake-content")).to eq(put_response)
      end
    end
  end
end
