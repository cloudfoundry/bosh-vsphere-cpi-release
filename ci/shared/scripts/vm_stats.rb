$LOAD_PATH.unshift File.expand_path( '../../../../../bosh-cpi-src/src/vsphere_cpi/lib', __FILE__)

require 'yaml'
require 'json'
require 'ostruct'
require 'logger'
require 'tmpdir'
require 'bosh/cpi'
require 'cloud'
require 'cloud/vsphere'

Bosh::Clouds::Config.configure(OpenStruct.new(
  logger: Bosh::Cpi::Logger.new(STDOUT),
  task_checkpoint: nil,
))

cpi_options = {'agent'=>{'ntp'=>['10.80.0.44']},
  'vcenters'=>
    [{'host'=>"#{ENV['BOSH_VSPHERE_CPI_HOST']}",
      'user'=>"#{ENV['BOSH_VSPHERE_CPI_USER']}",
      'password'=>"#{ENV['BOSH_VSPHERE_CPI_PASSWORD']}",
      'default_disk_type'=>'preallocated',
      'datacenters'=>
        [{'name'=>'vcpi-dc',
          'vm_folder'=>'vcpi-vm-folder',
          'template_folder'=>'vcpi-vm-folder',
          'disk_path'=>'vcpi-disk-folder',
          'datastore_pattern'=>'isc-cl1-ds-1',
          'persistent_datastore_pattern'=>'isc-cl1-ds-1',
          'allow_mixed_datastores'=>true,
          'clusters'=>[{'vcpi-cluster-1'=>{}}, {'vcpi-cluster-2'=>{}}]}],
      'http_logging'=>false,
      'request_id'=>nil}]}

cpi = VSphereCloud::Cloud.new(cpi_options)
datacenter = cpi.datacenter

cluster_counter = []
ds_counter = []
File.readlines(ARGV[0]).map do |line|
  cpi.client.find_vm_by_name(datacenter.mob, line.strip)
end.compact.each do |vm|
  cluster_counter << vm.runtime.host.parent.name
  ds_counter << vm.datastore
end
ds_counter = ds_counter.flatten.map{|ds| ds.name}.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}
cluster_counter = cluster_counter.inject(Hash.new(0)) { |total, e| total[e] += 1 ;total}

puts "************************SUMMARY**************************"
puts "Printing VM distribution summary"
puts "DS Summary : #{ds_counter}"
puts "Cluster Summary #{cluster_counter}"
puts "*********************************************************"