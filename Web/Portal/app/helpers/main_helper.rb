# Helper methods defined here can be accessed in any controller or view in the application

module Portal
  class App
    module MainHelper
      # def simple_helper_method
      # ...
      # end

      def buildTree(path,filter)
        # buildTree generuje na zaklade path strom, ktery navraci
        # navrat je pole poli obsahující cestu a název
        unless Dir.exist?(path)
          return Array.new
        end

          files = Dir.entries(path)
          files.delete_if{|val| (val == ".") || (val == "..")}

        out = Array.new

        files.each do |file|
          if File.file?(File.join(path,file))
            unless filter.nil?
              next unless file =~ filter
            end
            out.push([path,file])
          else
            # je slozkou
            out.push(buildTree(File.join(path,file),filter))
          end
        end
        return out
      end

      def userDir()
        storagePath = "temp"
        user = Account.current.surname unless Account.current.nil?
        user = user || "global"
        store = File.join(storagePath,user)
        logger.info store
        return store
      end

      def genOptions(data,filter)
        # generuje z data (ziskaneho z buildTree) nabídku v option
        out = ""
        data.each do |row|
          unless filter.nil?
            next unless row =~ filter
          end
          out += "<option value=\"#{row[0]}/#{row[1]}\">#{row[1]}</option>\n"
        end
        logger.info out
        return out
      end

    end

    helpers MainHelper
  end
end
