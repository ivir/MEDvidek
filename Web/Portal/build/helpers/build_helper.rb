# Helper methods defined here can be accessed in any controller or view in the application

module Portal
  class Build
    module BuildHelper
      # def simple_helper_method
      # ...
      # end
      def copyFile

      end

      def userDir()
        storagePath = "temp"
        user = Account.current.surname unless Account.current.nil?
        user = user || "global"
        store = File.join(storagePath,user)
        logger.info store
        return store
      end
    end
    helpers BuildHelper
  end
end
