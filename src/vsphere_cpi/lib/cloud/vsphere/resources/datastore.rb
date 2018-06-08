require 'cloud/vsphere/resources'

module VSphereCloud
  module Resources
    class Datastore
      include VimSdk
      include ObjectStringifier
      stringify_with :name, :mob
      PROPERTIES = %w(summary.freeSpace summary.capacity summary.accessible name)
      DISK_HEADROOM = 1024

      def self.build_from_client(client, datastore_mob, options={})
        # datastore_mob can be an empty array or nil. Return empty array immediately
        return [] if datastore_mob.nil? || datastore_mob.empty?
        ds_properties_map = client.cloud_searcher.get_properties(datastore_mob, Vim::Datastore, Datastore::PROPERTIES, options)
        ds_properties_map.values.map do |ds_properties|
          Datastore.new(
            ds_properties['name'],
            ds_properties[:obj],
            ds_properties['summary.accessible'],
            ds_properties['summary.capacity'].to_i / BYTES_IN_MB,
            ds_properties['summary.freeSpace'].to_i / BYTES_IN_MB,
          )
        end
      end

      # @!attribute name
      #   @return [String] datastore name.
      attr_accessor :name

      # @!attribute name
      #   @return [Boolean] datastore accessibility.
      attr_accessor :accessible

      # @!attribute mob
      #   @return [Vim::Datastore] datastore vSphere MOB.
      attr_accessor :mob

      # @!attribute total_space
      #   @return [Integer] datastore capacity.
      attr_accessor :total_space

      # @!attribute free_space
      #   @return [Integer] datastore free space when fetched from vSphere.
      attr_accessor :free_space

      # Creates a Datastore resource from the prefetched vSphere properties.
      #
      # @param [Hash] properties prefetched vSphere properties to build the
      #   model.
      def initialize(name, mob, accessible, total_space, free_space)
        @name = name
        @mob = mob
        @accessible = accessible
        if @accessible
          @total_space = total_space
          @free_space = free_space
        else
          @total_space = 0
          @free_space = 0
        end
      end

      def ==(other)
        instance_of?(other.class) && name == other.name
      end
      alias eql? ==

      def hash
        name.hash
      end

      def maintenance_mode?
        mob.summary.maintenance_mode != 'normal'
      end

      def accessible?
        @mob.host.any? do |host_mount|
          !host_mount.key.runtime.in_maintenance_mode
        end
      end

      # Returns whether there is any host which can access
      # the datastore from the cluster passed.
      #
      # @param [VSphereCloud::Resource::Cluster]
      #
      # @return [Boolean] Whether there exists a host that is not in
      # maintenance mode and is part of the very same cluster that datastore
      # can access
      #
      def accessible_from?(cluster)
        @mob.host.any? do |host_mount|
          next if host_mount.key.runtime.in_maintenance_mode
          cluster.host.include?(host_mount.key)
        end
      end

      # @return [String] debug datastore information.
      def inspect
        "<Datastore: / #@name>"
      end

      def debug_info
        "#{name} / #@mob / (#{free_space}MB free of #{total_space}MB capacity)"
      end
    end
  end
end
