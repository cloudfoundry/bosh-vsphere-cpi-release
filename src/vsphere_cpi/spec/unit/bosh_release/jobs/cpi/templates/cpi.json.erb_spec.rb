require 'spec_helper'
require 'json'
require 'yaml'

describe 'cpi.json.erb' do
  let(:cpi_specification_file) { File.absolute_path(File.join(jobs_root, 'vsphere_cpi/spec')) }

  subject(:parsed_json) do
    context_hash = YAML.load_file(cpi_specification_file)
    context = TemplateEvaluationContext.new(context_hash, manifest)
    renderer = ERBRenderer.new(context)
    parsed_json = JSON.parse(renderer.render(cpi_json_erb))
    parsed_json
  end

  let(:jobs_root) { File.join(File.dirname(__FILE__), '../../../../../../../../', 'jobs') }
  let(:cpi_json_erb) { File.read(File.absolute_path(File.join(jobs_root, 'vsphere_cpi/templates/cpi.json.erb'))) }
  let(:datastore_pattern) { 'datastore-pattern' }
  let(:persistent_datastore_pattern) { 'persistent-datastore-pattern' }
  let(:datastore_cluster_pattern) { 'datastore-cluster-pattern' }
  let(:persistent_datastore_cluster_pattern) { 'persistent-datastore-cluster-pattern' }
  let(:manifest) do
    {
      'properties' => {
        'vcenter' => {
          'host' => 'vcenter-address',
          'user' => 'vcenter-user',
          'password' => 'vcenter-password',
          'enable_auto_anti_affinity_drs_rules' => true,
          'enable_human_readable_name' => true,
          'upgrade_hw_version' => true,
          'vm_storage_policy_name' => 'VM Storage Policy',
          'http_logging' => true,
          'datacenters' => [
            {
              'name' => 'datacenter-1',
              'vm_folder' => 'vm-folder',
              'template_folder' => 'template-folder',
              'datastore_pattern' => datastore_pattern,
              'datastore_cluster_pattern' => datastore_cluster_pattern,
              'persistent_datastore_pattern' => persistent_datastore_pattern,
              'persistent_datastore_cluster_pattern' => persistent_datastore_cluster_pattern,
              'disk_path' => 'disk-path',
              'clusters' => ['cluster-1']
            }
          ]
        },
        'nats' => {
          'address' => 'nats_address.example.com',
          'password' => 'nats-password'
        }
      }
    }
  end

  it 'is able to render the erb given most basic manifest properties' do
    expect(subject).to eq({
      'cloud' => {
        'plugin' => 'vsphere',
        'properties' => {
          'agent' => {
            'mbus' => 'nats://nats:nats-password@nats_address.example.com:4222',
            'ntp' => [
              '0.pool.ntp.org',
              '1.pool.ntp.org'
            ]
          },
          'vcenters' => [
            {
              'datacenters' => [
                {
                  'allow_mixed_datastores' => true,
                  'clusters' => [
                    'cluster-1'
                  ],
                  'datastore_pattern' => 'datastore-pattern',
                  'datastore_cluster_pattern' => 'datastore-cluster-pattern',
                  'disk_path' => 'disk-path',
                  'name' => 'datacenter-1',
                  'persistent_datastore_cluster_pattern' => 'persistent-datastore-cluster-pattern',
                  'persistent_datastore_pattern' => 'persistent-datastore-pattern',
                  'template_folder' => 'template-folder',
                  'vm_folder' => 'vm-folder'
                }
              ],
              'host' => 'vcenter-address',
              'password' => 'vcenter-password',
              'user' => 'vcenter-user',
              'connection_options' => { 'ca_cert' => nil },
              'default_disk_type' => 'preallocated',
              'enable_auto_anti_affinity_drs_rules' => true,
              'enable_human_readable_name' => true,
              'memory_reservation_locked_to_max' => false,
              'upgrade_hw_version' => true,
              'http_logging' => true,
              'ensure_no_ip_conflicts' => true,
              'vm_storage_policy_name' => 'VM Storage Policy'
            }
          ],
        }
      }
    })
  end
  context 'when vcenter.vmx_options.disk.enableUUID is set globally' do
    let(:datastore_pattern) { nil }
    let(:datastore_cluster_pattern) { nil }
    let(:persistent_datastore_pattern) { nil }
    let(:persistent_datastore_cluster_pattern) { nil }
    before(:each) do

      manifest['properties']['vcenter']['vmx_options'] = { 'disk' => { 'enableUUID' => 1 } }
    end

    it 'renders the property' do
      subject['cloud']['properties']['vcenters'].each do |vcenter|
        expect(vcenter['vmx_options']).to eq(
          { 'disk' => { 'enableUUID' => 1 } }
        )
      end
    end

    it 'does not render the optional properties' do
      expect(subject['cloud']['properties']['vcenters'].first['datacenters'].first).to eq(
        {
          'allow_mixed_datastores' => true,
          'clusters' => [
            'cluster-1'
          ],
          'disk_path' => 'disk-path',
          'name' => 'datacenter-1',
          'template_folder' => 'template-folder',
          'vm_folder' => 'vm-folder'
        }
      )
    end
  end
  context 'when optional datacenter properties are not set' do
    let(:datastore_pattern) { nil }
    let(:datastore_cluster_pattern) { nil }
    let(:persistent_datastore_pattern) { nil }
    let(:persistent_datastore_cluster_pattern) { nil }

    it 'does not render the optional properties' do
      expect(subject['cloud']['properties']['vcenters'].first['datacenters'].first).to eq(
        {
          'allow_mixed_datastores' => true,
          'clusters' => [
            'cluster-1'
          ],
          'disk_path' => 'disk-path',
          'name' => 'datacenter-1',
          'template_folder' => 'template-folder',
          'vm_folder' => 'vm-folder'
        })
    end
  end

  context 'when nsx address is set' do
    before(:each) {
      manifest['properties']['vcenter']['nsx'] ={
        'address' => 'my-nsx-manager',
        'user' => 'my-nsx-user',
        'password' => 'fake'
      }
    }
    it 'renders the nsx section properly' do
      expect(subject['cloud']['properties']['vcenters'].first['nsx']['address']).to eq('my-nsx-manager')
      expect(subject['cloud']['properties']['vcenters'].first['nsx']['user']).to eq('my-nsx-user')
      expect(subject['cloud']['properties']['vcenters'].first['nsx']['password']).to eq('fake')
    end
  end

  context 'when vcenter address is also set' do
    before(:each) {
      manifest['properties']['vcenter'].merge!({
        'address' => 'vcenter-new-address'
      })
    }
    it 'uses the host key to set the vcenter host value' do
      expect(subject['cloud']['properties']['vcenters'].first['host']).to eq('vcenter-address')
    end
  end

  context 'when vcenter address is set and vcenter host is not set' do
    before(:each) {
      manifest['properties']['vcenter'].merge!({
        'address' => 'vcenter-new-address',
        'host' => nil
      })
    }
    it 'uses the address key to set vcenter host value' do
      expect(subject['cloud']['properties']['vcenters'].first['host']).to eq('vcenter-new-address')
    end
  end

  context 'when `default_disk_type` is `thin`' do
    before(:each) { manifest['properties']['vcenter']['default_disk_type'] = 'thin' }
    it 'renders the default_disk_type properly' do
      expect(subject['cloud']['properties']['vcenters'].first['default_disk_type']).to eq('thin')
    end
  end

  context 'when global storage policy is not provided' do
    before(:each) {
      manifest['properties']['vcenter'].delete('vm_storage_policy_name')
    }
    it 'renders the vcenter without storage policy' do
      expect(subject['cloud']['properties']['vcenters'].first['vm_storage_policy_name']).to be_nil
    end
  end
end

class TemplateEvaluationContext
  attr_reader :name, :index
  attr_reader :properties, :raw_properties
  attr_reader :spec

  def initialize(spec, manifest)
    @name = spec['job']['name'] if spec['job'].is_a?(Hash)
    @index = spec['index']
    properties = {}
    spec['properties'].each do |name, x|
      default = x['default']
      copy_property(properties, manifest['properties'], name, default)
    end
    @properties = openstruct(properties)
    @raw_properties = properties
    @spec = openstruct(spec)
  end

  def recursive_merge(hash, other)
    hash.merge(other) do |_, old_value, new_value|
      if old_value.class == Hash && new_value.class == Hash
        recursive_merge(old_value, new_value)
      else
        new_value
      end
    end
  end

  def get_binding
    binding.taint
  end

  def p(*args)
    names = Array(args[0])
    names.each do |name|
      result = lookup_property(@raw_properties, name)
      return result unless result.nil?
    end
    return args[1] if args.length == 2
    raise UnknownProperty.new(names)
  end

  def if_p(*names)
    values = names.map do |name|
      value = lookup_property(@raw_properties, name)
      return ActiveElseBlock.new(self) if value.nil?
      value
    end
    yield *values
    InactiveElseBlock.new
  end

  private

  def copy_property(dst, src, name, default = nil)
    keys = name.split('.')
    src_ref = src
    dst_ref = dst
    keys.each do |key|
      src_ref = src_ref[key]
      break if src_ref.nil? # no property with this name is src
    end
    keys[0..-2].each do |key|
      dst_ref[key] ||= {}
      dst_ref = dst_ref[key]
    end
    dst_ref[keys[-1]] ||= {}
    dst_ref[keys[-1]] = src_ref.nil? ? default : src_ref
  end

  def openstruct(object)
    case object
      when Hash
        mapped = object.inject({}) { |h, (k, v)| h[k] = openstruct(v); h }
        OpenStruct.new(mapped)
      when Array
        object.map { |item| openstruct(item) }
      else
        object
    end
  end

  def lookup_property(collection, name)
    keys = name.split('.')
    ref = collection
    keys.each do |key|
      ref = ref[key]
      return nil if ref.nil?
    end
    ref
  end

  class UnknownProperty < StandardError
    def initialize(names)
      @names = names
      super("Can't find property '#{names.join("', or '")}'")
    end
  end

  class ActiveElseBlock
    def initialize(template)
      @context = template
    end

    def else
      yield
    end

    def else_if_p(*names, &block)
      @context.if_p(*names, &block)
    end
  end

  class InactiveElseBlock
    def else;
    end

    def else_if_p(*_)
      InactiveElseBlock.new
    end
  end
end

class ERBRenderer
  def initialize(context)
    @context = context
  end

  def render(erb_content)
    erb = ERB.new(erb_content)
    erb.result(@context.get_binding)
  end
end
