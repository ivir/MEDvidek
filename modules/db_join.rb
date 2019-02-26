require_relative('../module_med')
require_relative('../db_storage')


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
    if @source.is_a?(Array)
      @source.each do |input|
        stor.join(@memory[input],@pair)
      end
    else
      stor.join(@memory[@source],@pair)
    end

    #puts @memory
  end
end

class DBSort < ModuleMED
  def initialize
    @db = Dataset.new

  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @source = fdata["source"]
    @sort = fdata["sort"]
    @asc = (fdata["asceding"].nil?)? true : false

    @memory["output"] = @store
  end

  def execute(fdata)
    # spusteni zpracovani
    stor = @memory[@source]
    stor.sort(@sort,@asc)

    #puts @memory
  end
end