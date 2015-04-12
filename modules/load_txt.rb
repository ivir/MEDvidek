require_relative('../module_med')

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'

class LoadTXT < ModuleMED
  def initialize
    @db = SQLite3::Database.new(":memory:")
    @db.execute("Create table data (line varchar(255));")
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
    @db.execute "delete from data;"
    data = File.open(@file)
    data.each_line { |line|
      printf(line)
      @db.execute "insert into data values (?)", [line]
    }
    printf("vkládání provedeno")
    fdata = @db
  end
end