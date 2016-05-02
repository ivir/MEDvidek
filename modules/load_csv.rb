require_relative('../module_med')
require_relative('../db_storage')


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

    data.each_line { |line|
      #printf(line)
      line.tr!("\n","")
      values = line.split(",") if @type == "csv"
      values = line.split(";") if @type == "ssv"
      if(i <= 0)
        values.each { |column|
          @db.add_column(column,nil)
        }
        i = i + 1
        next
      else
        #print "#{values}\n"
        td.clear()
        values.each { |tval|
          tval.gsub!(/^".*"$/,'')

          if(tval =~ /^[+-]{0,1}\d+\s*$/)
            td.push(Integer(tval));
            next
          end
          if(tval =~ /^[+-]?\d+\s*\d*\.\d+[e+\-\d]*\s*$/)
              td.push(Float(tval));
              next
          end
          if(tval =~ /^[+-]?\d+[\S\s]*\d*,?\d+[e+\-\d]*\s*$/)
            #pouzita ceska forma zapisu
            tval.gsub!(/[^+\-0-9,e]/,'')
            tval.tr!(",",".")
            td.push(Float(tval));
            next
          end
          #nebylo rozpoznano co to jest -> ulozime jak to je
          td.push(String(tval))
        }
        #print "#{td}\n"
        @db.push td
      end
      i = i + 1
    }
    #@store = @db
    #print @db
    @memory.store(@store,@db)
    #print @store
  end
end