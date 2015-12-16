module VSphereCloud
  class Resources
    class PersistentDisk < Disk
      def create_spec(controller_key)
        spec(independent: true, controller_key: controller_key)
      end
    end
  end
end
