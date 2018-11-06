require 'spec_helper'

module VSphereCloud
  describe Pbm do
    subject(:pbm) do
      described_class.new(
        pbm_api_uri: pbm_api_uri,
        http_client: http_client,
        vc_cookie: vc_cookie
      )
    end
    let(:profile_manager) { instance_double(VimSdk::Pbm::Profile::ProfileManager) }
    let(:service_content) { instance_double(VimSdk::Pbm::ServiceInstanceContent, profile_manager: profile_manager) }
    let(:service_instance) { instance_double(VimSdk::Pbm::ServiceInstance, retrieve_content: service_content) }
    let(:pbm_api_uri) { URI.parse('https://fake-host/pbm/sdk') }
    let(:http_client) { instance_double(CpiHttpClient) }
    let(:vc_cookie) { 'testcookie' }

    before do
      stub_adapter = instance_double(VimSdk::Soap::PbmStubAdapter)
      allow(VimSdk::Soap::PbmStubAdapter).to receive(:new).with(pbm_api_uri, 'pbm.version.version12', http_client, vc_cookie: vc_cookie).and_return(stub_adapter)
      allow(VimSdk::Pbm::ServiceInstance).to receive(:new).with('ServiceInstance', stub_adapter).and_return(service_instance)
    end

    describe '#find_policy' do
      let(:profile) { instance_double(VimSdk::Pbm::Profile::Profile, name: 'VM Encryption Policy', profile_id: 1)}
      before do
        profile_ids = [1]
        allow(profile_manager).to receive(:query_profile).and_return(profile_ids)
        allow(profile_manager).to receive(:retrieve_content).and_return([profile])
      end
      it 'should find and return the given policy' do
        policy = pbm.find_policy('VM Encryption Policy')
        expect(policy.profile_id).to eq(1)
        expect(policy.name).to eq('VM Encryption Policy')
      end

      it 'should raise an error if policy is not found' do
        expect{ pbm.find_policy('Non-existent-policy') }.to raise_error('Storage Policy: Non-existent-policy not found')
      end
    end
  end
end
