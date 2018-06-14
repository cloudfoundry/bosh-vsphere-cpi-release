#! /usr/bin/env ruby

$LOAD_PATH.unshift '/var/vcap/packages/vsphere_cpi/lib'

unless ARGV[0]
  puts 'Usage: pry.rb <director_config_yaml>'
  exit 1
end

require 'yaml'

require 'cloud'
require 'cloud/vsphere'

bosh_director_config = OpenStruct.new(logger: Logger.new("/dev/null"), uuid: 'uuid', task_checkpoint: nil)

Bosh::Clouds::Config.configure(bosh_director_config)

director_config = YAML.load_file(ARGV[0])
vsphere_properties = director_config['cloud']['properties']

new_clusters = ARGV[1..-1]
new_clusters.each do |cl|
  puts "Adding cluster : #{cl}"
  vsphere_properties['vcenters'][0]['datacenters'][0]['clusters'] << {cl => {}}
end

puts "\nNew vSphere properties "
puts "-----------------------------------------------------------------------\n"
puts JSON.pretty_generate(vsphere_properties['vcenters'][0]['datacenters'])

cpi = VSphereCloud::Cloud.new(vsphere_properties)

module VSphereCloud
  class ClusterPicker
    include Logger
    def best_cluster_placement(req_memory:, disk_configurations:)
      clusters = filter_on_memory(req_memory)
      if clusters.size == 0
        raise Bosh::Clouds::CloudError,
          "No valid placement found for requested memory: #{req_memory}\n\n#{pretty_print_cluster_memory}"
      end

      placement_options = clusters.map do |cluster|
        datastore_picker = DatastorePicker.new(@disk_headroom)
        datastore_picker.update(cluster.accessible_datastores)

        begin
          placement = datastore_picker.best_disk_placement(disk_configurations)
          placement[:memory] = cluster.free_memory
          [cluster.name, placement]
        rescue Bosh::Clouds::CloudError
          puts "Cluster #{cluster.name} got rejected in datastore picker\n\n"
          nil # continue if no placements exist for this cluster
        end
      end.compact.to_h

      puts "Result of datastore picker for all clusters is\n"
      pretty_print_placements(placement_options)
      puts "\n\n"

      if placement_options.size == 0
        disk_string = DatastorePicker.pretty_print_disks(disk_configurations)
        raise Bosh::Clouds::CloudError,
          "No valid placement found for disks:\n#{disk_string}\n\n#{pretty_print_cluster_disk}"
      end
      if placement_options.size == 1
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_minimum_disk_migrations(placement_options)
      puts "Result of cluster picker after sort&filter on disk migration is \n"
      pretty_print_placements(placement_options)
      puts "\n\n"
      if placement_options.size == 1
        puts "Skipping free memory and free space sort&filter since only 1 placement left\n\n"
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_max_free_space(placement_options)
      puts "Result of cluster picker after sort&filter on free space is \n"
      pretty_print_placements(placement_options)
      puts "\n\n"
      if placement_options.size == 1
        puts "Skipping free memory sort&filter since only 1 placement left\n\n"
        return format_final_placement(placement_options)
      end

      placement_options = placements_with_max_free_memory(placement_options)
      puts "Result of cluster picker after sort&filter on free memory is \n"
      pretty_print_placements(placement_options)
      puts "\n\n"
      format_final_placement(placement_options)
    end
  end
end

def pretty_print_placements(placements)
  puts "-----------------------------------------------------------------------\n"
  placements.each do |plkey, plval|
    puts "  Cluster is  : #{plkey} [=====>> Shows the DS which got the disk]"
    puts "  \tDatastore Placement Summary : \n"
    printf"  \t\t%-40s\t%-40s\t%-40s\n", "Datastore", "Free Space", "Disks"
    plval[:datastores].each do |dskey, dsprop|
      if dsprop[:disks].size != 0
        printf"\t=====>> %-40s\t%-40s\t%-40s\n" ,"#{dskey}", "#{dsprop[:free_space]}", "#{dsprop[:disks]}"
      else
        printf"\t\t%-40s\t%-40s\t%-40s\n" ,"#{dskey}", "#{dsprop[:free_space]}", "#{dsprop[:disks]}"
      end
    end
    puts "  \tBalance Score  : #{plval[:balance_score]}"
    puts "  \tMigration Size : #{plval[:migration_size]}"
    puts "  \tFree Mem       : #{plval[:memory]}"
    puts ""
  end
end


puts "****************************START LOG************************************\n\n"
puts "Cluster Summary"
puts "-----------------------------------------------------------------------"

# Print everything irrespective of what has been specified in the config.
# Config just aids easy initialization of cloud object
cpi.datacenter.mob.host_folder.child_entity.each do |child|
  # Skip the hosts
  next unless child.is_a?(VimSdk::Vim::ClusterComputeResource)

  puts "Cluster : #{child.name}"
  puts " \t***** Memory Stats *****"
  printf "\t\t%-40s\t%-40s\t%-40s\n", "Free Memory(Perf Counter)", "Effective-Mem", "Total-Mem"

  cl_provider = VSphereCloud::Resources::ClusterProvider.new(:datacenter_name => cpi.datacenter.mob.name, :client => cpi.client, :logger => cpi.logger)
  # create a cluster assuming there is no resource pool in config
  clresource = cl_provider.find(child.name, VSphereCloud::ClusterConfig.new(child.name, {:resource_pool => nil}))

  printf "\t\t%-40s\t%-40s\t%-40s\n", "#{clresource.free_memory rescue "N/A"}", "#{clresource.mob.summary.effective_memory rescue "N/A"}", "#{clresource.mob.summary.total_memory/VSphereCloud::Resources::BYTES_IN_MB rescue "N/A"}"
  puts "\n"

  # print every resource pool that exists under that cluster
  puts " \t*****Resource Pools Stats *****"
  printf "\t\t%-40s\t%-40s\t%-40s\t%-40s\n", "Name", "Free Memory", "Max Usage", "Overall Usage"

  clresource.mob.resource_pool&.resource_pool.each do |rpool|
    rpool_mem = 0
    if rpool.summary&.runtime&.overall_status == "green"
      memory = rpool.summary.runtime.memory  rescue "Cannot Fetch Pool Memory"
      rpool_mem = (memory.max_usage - memory.overall_usage) / VSphereCloud::Resources::BYTES_IN_MB
    end
    printf "\t\t%-40s\t%-40s\t%-40s\t%-40s\n", "#{rpool.name}", "#{rpool_mem}", "#{memory.max_usage}", "#{memory.overall_usage}"
  end

  puts"\n"
  # Print datastores that exist under this cluster
  puts " \t*****Datastore Stats *****"
  printf "\t\t%-40s\t%-40s\t%-40s\t%-40s\n", "Name", "Accessible", "Total Space", "Free Space"

  clresource.mob.datastore&.each do |ds|
    ds_resource = VSphereCloud::Resources::Datastore.build_from_client(cpi.client, [ds])
    ds_resource = ds_resource.first
    printf "\t\t%-40s\t%-40s\t%-40s\t%-40s\n", "#{ds_resource.name}", "#{ds_resource.accessible}", "#{ds_resource.total_space}", "#{ds_resource.free_space}"
  end
  puts "\n\n\n"
end

# Simulate Dry Run on the clusters provided
clpicker = VSphereCloud::ClusterPicker.new
clpicker.update(cpi.datacenter.clusters)
# DS Pattern is all datastores for now
cpi.define_singleton_method(:logger) do
  @logger ||= ::Logger.new('/dev/null')
end

# Let's assume we need a vm of ram size 8192 MB
puts "============================================Simulating a dry run with various target pattern and VM of memory size #{8192}===================================================\n\n"
result = {}
pattern_list = ['isc*', '^.*$', 'local*', '^[^n]*$']
pattern_list.each do |pattern|
  puts "Simulating for pattern #{pattern} \n\n"

  dummy_disk_config = VSphereCloud::DiskConfig.new(size: 10000, ephemeral: true, target_datastore_pattern: pattern)
  cluster_list = []
  datastore_list = []

  100.times do
    placements = clpicker.best_cluster_placement(req_memory: 8192, disk_configurations: [dummy_disk_config])
    cluster_list << placements.keys.first
    datastore_list << placements.values[0].values[0]
  end

  cc = cluster_list.each_with_object(Hash.new(0)) { |cluster, acc| acc[cluster] += 1 }
  dc = datastore_list.each_with_object(Hash.new(0)) { |ds, acc| acc[ds] += 1 }

  result[pattern] = {}
  result[pattern][:cc] = cc
  result[pattern][:dc] = dc
end
puts "\n============================================Simulation END===================================================\n\n"

result.each do |key, val|
  puts "Stats for the pattern #{key} are : \n"
  printf "Cluster Spread"
  puts JSON.pretty_generate(val[:cc])
  printf "Datastore Spread"
  puts JSON.pretty_generate(val[:dc])
end

puts "\n"


