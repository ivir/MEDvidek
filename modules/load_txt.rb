require_relative('../module_med')

gem 'sqlite3', '~> 1.3.10'

class LoadTXT < ModuleMed
  def initialize
    @db = SQLite3::Database.new(":memory:")

  end
  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani

  end

  def properties(fdata)
    # navraci seznam podporovanych vstupu a vystupu

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
    data = File.open(@file)
    data.readline.each { |line|
      fdata
    }
  end
end