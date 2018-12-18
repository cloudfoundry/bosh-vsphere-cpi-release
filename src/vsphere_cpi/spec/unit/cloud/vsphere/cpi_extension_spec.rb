require 'spec_helper'

module VSphereCloud
  describe VCPIExtension, fake_logger: true do
    subject { described_class }

    let(:ext_mgr) { instance_double('VimSdk::Vim::ExtensionManager') }
    let(:client) { instance_double('VSphereCloud::VCenterClient', :logout => nil) }
    before do
      allow(subject).to receive(:vc_client).and_return(client)
    end

    describe '#extension_is_registered?' do
      it 'returns true when extension is registered with VC' do
        expect(client).to receive_message_chain(:service_content, :extension_manager).and_return(ext_mgr)
        expect(ext_mgr).to receive(:find_extension).with(described_class::DEFAULT_VSPHERE_CPI_EXTENSION_KEY).and_return('Extension')
        expect(subject.send(:extension_is_registered?)).to eq(true)
      end

      it 'returns false when extension is not registered with VC' do
        expect(client).to receive_message_chain(:service_content, :extension_manager).and_return(ext_mgr)
        expect(ext_mgr).to receive(:find_extension).with(described_class::DEFAULT_VSPHERE_CPI_EXTENSION_KEY).and_return(nil)
        expect(subject.send(:extension_is_registered?)).to eq(false)
      end
    end

    describe '#build_extension' do
      it 'builds extension with specified key and version' do
        extension = subject.send(:build_extension, key: 'Foo', version: 'Bar')
        expect(extension.key). to eq('Foo')
        expect(extension.version).to eq('Bar')
        expect(extension.description.label).to eq(subject::DEFAULT_VSPHERE_CPI_EXTENSION_LABEL)
        expect(extension.shown_in_solution_manager).to be true
      end
    end

    describe '#create_cpi_extension' do
      it 'creates an extension if it does not exist' do
        expect(subject).to receive(:extension_is_registered?).and_return(false)
        expect(subject).to receive(:register_extension).with(anything).and_return(nil)
        subject.create_cpi_extension(client)
      end

      it 'rescues all errors and suppresses them' do
        expect(subject).to receive(:extension_is_registered?).and_raise('boom')
        subject.create_cpi_extension(client)
      end
    end
  end
end
