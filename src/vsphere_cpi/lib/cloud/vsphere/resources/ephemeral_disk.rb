module VSphereCloud
  class Resources
    class EphemeralDisk < Disk
      DISK_NAME = 'ephemeral_disk'

      def create_spec(controller_key)
        spec(create: true, controller_key: controller_key)
      end
    end
  end
end
