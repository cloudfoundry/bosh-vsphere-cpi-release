require 'spec_helper'

describe 'NSXTPolicy' do
  it 'encodes [' do
    client = NSXTPolicy::ApiClient.new
    actualRespone = client.build_request_url('this has a [ bracket')
    expect(actualRespone).to eq('https://nsxmanager.your.domain/policy/api/v1/this%20has%20a%20%5B%20bracket')
  end
  it 'encodes ]' do
    client = NSXTPolicy::ApiClient.new
    actualRespone = client.build_request_url('this has a ] bracket')
    expect(actualRespone).to eq('https://nsxmanager.your.domain/policy/api/v1/this%20has%20a%20%5D%20bracket')
  end
end

describe 'NSXT' do
  it 'encodes [' do
    client = NSXT::ApiClient.new
    actualRespone = client.build_request_url('this has a [ bracket')
    expect(actualRespone).to eq('https://nsxmanager.your.domain/api/v1/this%20has%20a%20%5B%20bracket')
  end
  it 'encodes ]' do
    client = NSXT::ApiClient.new
    actualRespone = client.build_request_url('this has a ] bracket')
    expect(actualRespone).to eq('https://nsxmanager.your.domain/api/v1/this%20has%20a%20%5D%20bracket')
  end
  context 'call_api' do
    before do
      allow_any_instance_of(Logger).to receive(:debug) # don't clutter the test output
    end
    it 'should succeed when the API returns 200' do
      typh_response = double('Typhoeus::Response', :success? => true, :timed_out? => false, :code => 200, :body => '{}', :headers => ['some-header'], :status_message => 'OK')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)
      client = NSXT::ApiClient.new
      response = client.call_api('PUT', 'api/v0/throttled_endpoint')
      expect(response).to match_array([nil,200,['some-header']]) # s
    end
    it 'should retry when the API first returns 429 then succeed afterwards' do
      throttled_typh_response = double('Typhoeus::Response', :success? => false, :timed_out? => false, :code => 429, :body => '{}', :headers => ['some-header'], :status_message => 'Too many requests')
      successful_typh_response = double('Typhoeus::Response', :success? => true, :timed_out? => false, :code => 200, :body => '{}', :headers => ['some-header'], :status_message => 'OK')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(
        throttled_typh_response,
        successful_typh_response
      )
      client = NSXT::ApiClient.new
      response = client.call_api('PUT', 'api/v0/throttled_endpoint')
      expect(response).to match_array([nil,200,['some-header']]) # s
    end
    it 'should eventually fail when it keeps getting 429s' do
      typh_response = double('Typhoeus::Response', :success? => false, :timed_out? => false, :code => 429, :body => '{}', :headers => ['some-header'], :status_message => 'Too many requests')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)
      allow_any_instance_of(Kernel).to receive(:sleep) # I don't want the test to take 12 seconds
      client = NSXT::ApiClient.new
      expect { client.call_api('PUT', 'api/v0/throttled_endpoint') }.to raise_error(NSXT::ApiCallError)
    end

    it 'handles non-JSON responses' do
      typh_response = instance_double(Typhoeus::Response, success?: false, timed_out?: false, code: 500, body: '', headers: ['some-header'], status_message: 'Server error', return_code: :ok, return_message: 'Some libcurl message')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)

      client = NSXT::ApiClient.new
      expect { client.call_api('PUT', 'api/v0/throttled_endpoint') }.to raise_error(NSXT::ApiCallError)
    end
  end
end

describe 'NSXTPolicy' do
  context 'call_api' do
    before do
      allow_any_instance_of(Logger).to receive(:debug) # don't clutter the test output
    end
    it 'should succeed when the API returns 200' do
      typh_response = double('Typhoeus::Response', :success? => true, :timed_out? => false, :code => 200, :body => '{}', :headers => ['some-header'], :status_message => 'OK')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)
      client = NSXTPolicy::ApiClient.new
      response = client.call_api('PUT', 'api/v0/throttled_endpoint')
      expect(response).to match_array([nil,200,['some-header']]) # s
    end
    it 'should retry when the API first returns 429 then succeed afterwards' do
      throttled_typh_response = double('Typhoeus::Response', :success? => false, :timed_out? => false, :code => 429, :body => '{}', :headers => ['some-header'], :status_message => 'Too many requests')
      successful_typh_response = double('Typhoeus::Response', :success? => true, :timed_out? => false, :code => 200, :body => '{}', :headers => ['some-header'], :status_message => 'OK')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(
        throttled_typh_response,
        successful_typh_response
      )
      client = NSXTPolicy::ApiClient.new
      response = client.call_api('PUT', 'api/v0/throttled_endpoint')
      expect(response).to match_array([nil,200,['some-header']]) # s
    end
    it 'should eventually fail when it keeps getting 429s' do
      typh_response = double('Typhoeus::Response', :success? => false, :timed_out? => false, :code => 429, :body => '{}', :headers => ['some-header'], :status_message => 'Too many requests')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)
      allow_any_instance_of(Kernel).to receive(:sleep) # I don't want the test to take 12 seconds
      client = NSXTPolicy::ApiClient.new
      expect { client.call_api('PUT', 'api/v0/throttled_endpoint') }.to raise_error(NSXTPolicy::ApiCallError)
    end

    it 'handles non-JSON responses' do
      typh_response = instance_double(Typhoeus::Response, success?: false, timed_out?: false, code: 500, body: '', headers: ['some-header'], status_message: 'Server error', return_code: :ok, return_message: 'Some libcurl message')
      allow_any_instance_of(Typhoeus::Request).to receive(:run).and_return(typh_response)

      client = NSXTPolicy::ApiClient.new
      expect { client.call_api('PUT', 'api/v0/throttled_endpoint') }.to raise_error(NSXTPolicy::ApiCallError)
    end
  end
end