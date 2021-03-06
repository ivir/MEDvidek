require_relative('../module_med')
require_relative('../db_storage')

require 'csv'

class LoadCSV < ModuleMED
  def initialize
    @db = Dataset.new

  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @type = fdata["type"]
    @file = fdata["file"]
    @rename = fdata["rename"]

    @file = @memory[@file] unless @memory[@file].nil?

    @memory["output"] = @store
  end

  def status(fdata)
    #vysledek posledni operace

  end

  def preprocessing(fdata)
    # navraci recept, ktery se ma pouzit na data pred vstupem
    nil
  end

  def postprocessing(fdata)
    # navraci recept, ktery se ma pouzit na data po zpracovani timto modulem
    nil
  end

  def execute(fdata)
    # spusteni zpracovani

    @file = @file[0] if @file.is_a?(Array)

    @db.clear
    data = File.open(@file)
    i = 0
    td = Array.new

    case @type
      when 'csv'
        separator = ','
      when 'ssv'
        separator = ';'
      else
        separator = ','
    end

    CSV.foreach(@file,col_sep: separator,converters: :numeric) do |line|
      if(i <= 0)
        line.each { |column|
          # prevadi se na mala pismena kvuli vypoctum
            @db.add_column(column.downcase(),nil)
        }
        i = i + 1
        next
      else
        td.clear()
        line.each { |tval|
          if tval.nil? then
            td.push(nil)
            next
          end

          unless tval.is_a?(String)
            #povedla se konverze na cislo -> rovnou ulozime
            td.push(tval)
            next
          end
          tval.gsub!(/^".*"$/,'')

          if(tval =~ /^[+-]{0,1}\d+\s*$/)
            td.push(Integer(tval));
            next
          end

          if(tval =~ /^\s*[+-]{0,1}\d+[\s\d]*$/) #osetreni mobilnich cisel
            tval.gsub!(/[^+\-0-9,e]/,'')
            tval.rstrip!
            tval.lstrip!
            td.push(Integer(tval));
            next
          end

          if(tval =~ /^[+-]?\d+\s*\d*\.\d+[e+\-\d]*\s*$/)
            td.push(Float(tval));
            next
          end

          if(tval =~ /^\d+-\d+$/)
            td.push(String(tval))
            next
          end

          if(tval =~ /^[+-]?\d+[\S\s]*\d*,?\d+[e+\-\d]*\s*$/)
            #pouzita ceska forma zapisu
            #puts "Prevedeno z ceske normy"
            tval.gsub!(/[^+\-0-9,e]/,'')
            tval.tr!(",",".")
            begin # pokud regularni vyraz zachyti retezec tvoreny cislem a pomlckou, pak to ulozi jako retezec
              val = Float(tval)
            rescue
              val = String(tval)
            end
            td.push(val)
            next
          end
          if tval.nil?
            td.push(0)
            next
          end
          #nebylo rozpoznano co to jest -> ulozime jak to je
          td.push(String(tval))
        }
        @db.push td
      end
      i = i + 1
    end
    #@store = @db
    #print @db
    @memory.store(@store,@db)
    #print @store
  end
end