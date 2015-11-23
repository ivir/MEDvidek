require_relative('../module_med')
require_relative('../db_storage')

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'


class LoadCSV < ModuleMED
  def initialize
    @db = Dataset.new

  end
  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani

  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @type = fdata["type"]
    @file = fdata["file"]

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
    @db.clear
    data = File.open(@file)
    i = 0
    data.each_line { |line|
      #printf(line)
      values = line.split(",")
      print i
      if(i <= 0)
        values.each { |column|
          @db.add_column(column,nil)
        }
        i = i + 1
        next
      else
        @db.push values
      end
      i = i + 1
    }
    #@store = @db
    print @db
    @memory.store(@store,@db)
    #print @store
  end
end