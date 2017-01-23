# Helper methods defined here can be accessed in any controller or view in the application

module Portal
  class Storage
    module ListHelper
      # def simple_helper_method
      # ...
      # end

      def userDir()
        storagePath = "temp"
        user = Account.current.surname unless Account.current.nil?
        user = user || "global"
        store = File.join(storagePath,user)
        return store
      end

    end

    helpers ListHelper
  end
end
