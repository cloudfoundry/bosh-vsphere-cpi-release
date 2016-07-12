require 'cloud/vsphere/resources'

module VSphereCloud
  module Resources
    class Datastore
      include VimSdk
      include ObjectStringifier
      stringify_with :name, :mob
      PROPERTIES = %w(summary.freeSpace summary.capacity summary.accessible name)
      DISK_HEADROOM = 1024

      def self.build_from_client(client, datastore_mob)
        ds_properties_map = client.cloud_searcher.get_properties(datastore_mob, Vim::Datastore, Datastore::PROPERTIES)
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

      # @return [String] debug datastore information.
      def inspect
        "<Datastore: #@mob / #@name>"
      end

      def debug_info
        "#{name} (#{free_space}MB free of #{total_space}MB capacity)"
      end
    end
  end
end
