module VSphereCloud
  class DiskConfig

    attr_reader :size, :existing_datastore_name, :target_datastore_pattern
    attr_accessor :cid

    def initialize(cid:nil,size:,ephemeral:false,existing_datastore_name:nil,target_datastore_pattern:)
      @cid = cid
      @size = size
      @ephemeral = ephemeral
      @existing_datastore_name = existing_datastore_name
      @target_datastore_pattern = target_datastore_pattern
    end
    
    def ephemeral?
      @ephemeral
    end

    def inspect
      "Disk ==> Disk CID:#{cid} Size:#{size} Ephemeral:#{ephemeral?} Target-DS:#{target_datastore_pattern} Existing-DS:#{existing_datastore_name}"
    end
  end
end