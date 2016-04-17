require_relative('../module_med')
require_relative('../db_storage')

class ExportJSON < ModuleMED
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
    @file = fdata["file"]
    @ping = fdata["ping"]
    @columns = fdata["columns"]

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
    unless @ping.nil?
      return "Ping:\n\turl:#{ping}"
    end

    nil
  end

  def execute(fdata)
    # spusteni zpracovani

    i = 0
    datas = Array.new
    td = Array.new

    ds = @memory[@store]
    ds.each_with_index do |row,index|
      data = "{"
      td.clear
      row.each_pair do |key,value|
        td.push("#{format(key)}: #{format(value)}")
      end

      data +=td.join(",")
      data += "}"
      datas.push(data)
    end
    data = "[#{datas.join(",")}]"
    print data
    #File.write(@file,data)
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

    def format(input)
      case input
        when Float then
          return input.to_s
        when BigDecimal then
          return input.to_s('F')
        else
          return "\"#{input.to_s}\""
      end
    end

end