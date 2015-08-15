require_relative('../module_med')
require_relative('../db')

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'


class LoadCSV < ModuleMED
  def initialize
    @db = DB.create()
  end
  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani

  end

  def properties(fdata)
    # navraci seznam podporovanych vstupu a vystupu

    @type = fdata["type"]
    @file = fdata["file"]

    printf("Data načtena")

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
      printf(line)
      values = line.split(",")
      if(i == 0)
        values.each { |column|
          @db.add_column(column)
        }
        @db.prepare()
        ++i
        continue
      end
      @db.insert values
    }
    printf("vkládání provedeno")
    fdata = @db
  end
end