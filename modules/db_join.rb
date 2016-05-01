require_relative('../module_med')
require_relative('../db_storage')

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'


class DBJoin < ModuleMED
  def initialize
    @db = Dataset.new

  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @source = fdata["source"]
    @pair = fdata["pair"]

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
    stor = @memory[@store]
    stor.join(@memory[@source],@pair)

    puts @memory
  end
end