require_relative('../module_med')
require_relative('../db_storage')

class ExportCSV < ModuleMED
  def initialize
    @db = Dataset.new

  end
  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani

  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["source"]
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

    i = 0
    td = Array.new
    data = ""

    ds = @memory[@store]
    header = separate(ds.columns)
    data += header + "\n"
    ds.each do |row|
      data += separate(row.values) + "\n"
    end

    File.write(@file,data)
  end

  private
    def separate(arr)
      case @type
        when 'csv'
          separator = ','
        when 'ssv'
          separator = ';'
        else
          separator = ','
      end
      arr.join(separator)
    end

end