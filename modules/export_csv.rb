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
    nil
  end

  def execute(fdata)
    # spusteni zpracovani

    i = 0
    td = Array.new
    data = ""

    ds = @memory[@store]
    if(@columns.nil?)
      header = separate(ds.columns)
      data += header + "\n"
      ds.each do |row|
        data += separate(row.values) + "\n"
      end
    else
      #resime prejmenovnai prvku, apod
      arr = Array.new
      @columns.each do |col|
        unless (col.class == Hash)
          arr.push(col)
        else
          col.each_pair do |key,value|
            arr.push(value)
          end
        end
      end
      data += separate(arr) + "\n"
      # nyni nahrajeme data jak je chteji
      ds.each do |row|
        arr.clear
        @columns.each do |col|
          unless col.class == Hash
            arr.push(format(row[col]))
          else
            col.each_pair do |key,value|
              arr.push(format(row[key]))
            end
          end
        end
        data += separate(arr) + "\n"
      end
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

    def format(input)
      case input
        when Float then
          return input.to_s
        when BigDecimal then
          return input.to_s('F')
        else
          print "#{input.class} s daty #{input}\n"
          return input.to_s
      end
    end

end