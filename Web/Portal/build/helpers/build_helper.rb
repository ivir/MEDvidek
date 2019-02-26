# Helper methods defined here can be accessed in any controller or view in the application

module Portal
  class Build
    module BuildHelper
      # def simple_helper_method
      # ...
      # end
      def copyFile

      end

      #navraci cestu k adresari, TODO - sjednotit zdroj s ostatnimi moduly
      def userDir()
        storagepath = "temp"
        user = Account.current.surname unless Account.current.nil?
        user = user || "global"
        store = File.join(storagepath,user)
        logger.info store
        store
      end

      #osetreni snahy uniknout z mista ukladani
      def protectSandbox(path)
        data = path.gsub(/\.+\//,'')
        data
      end

      #nahrazuje klicova slova
      def magicConstants(value)
        begin
          change = false
          case value
            when /.*%DATE%.*/
              value.sub!(/%DATE%/,Date.today().to_s)
              change = true
              logger.debug "NAHRAZENO #{value}"
              break
            when /.*%MONTH%.*/
              value.sub!(/%MONTH%/,Date.today().strftime("%Y%m"))
              change = true
              break
          end
        end while change
        value
      end

      def modifyPaths(data)
        # nahradime nazvy souboru za uplne cesty k nemu;
        # nahrada se provede v okamziku, kdy soubor existuje;

        # samostatne je osetrena situace, kdy se jedna o Export nebo Report dat, pak se u parametru file provede nahrada
        data.each { |modu|
          modu.each { |modul,parameters|
            next unless parameters.respond_to?(:each)
            parameters.each {|k, val|
              next unless val.is_a?(String)

              parameters[k] = magicConstants(val)

              soubor = parameters[k]
              uplna_cesta = File.join(userDir(),soubor)
              uplna_cesta = protectSandbox(uplna_cesta)
              parameters[k] = uplna_cesta if File.exist?(uplna_cesta)
              if( (k == "file") && (modul.include?("Export") || modul.include?("Report")))
                parameters[k] = uplna_cesta
                path = File.dirname(uplna_cesta)
                logger.debug "Vysledek zdali adresar existuje #{Dir.exist?(path)}"
                FileUtils.mkdir_p(path) unless Dir.exist?(path)
              end
            }
          }
        }
      end

      def verifyYAML(file)
        #pokusi se otevrit YAML soubor pro zpracovani
        return false unless File.exist?(file) #koncime, pokud neexistuje
        begin
          return !!YAML.load(file) #navrati true/false
        rescue Exception => e
          return false
        end

      end


    end
    helpers BuildHelper
  end
end
