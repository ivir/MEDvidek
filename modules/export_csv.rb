require_relative('../module_med')
require_relative('../db_storage')

require 'csv'

class ExportCSV < ModuleMED
  def initialize
    @db = Dataset.new

  end
  def properties(memory,fdata)
    @store = fdata["source"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @type = fdata["type"]
    @file = fdata["file"]
    @columns = fdata["columns"]
    @enviroment = fdata["enviroment"]
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

    case @type
      when 'csv'
        separator = ','
      when 'ssv'
        separator = ';'
      else
        separator = ','
    end

    ds = @memory[@store]

    CSV.open(@file,"w",col_sep: separator) { |rcsv|
      if(@columns.nil?)
        rcsv << ds.columns
        ds.each do |row|
          rcsv << row.values
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
        rcsv << arr
        # nyni nahrajeme data jak je chteji
        ds.each do |row|
          arr.clear
          @columns.each do |col|
            unless col.class == Hash
              if row[col].nil?
                arr.push(format(row[col.downcase]))
              else
                arr.push(format(row[col]))
              end

            else
              col.each_pair do |key,value|
                if row[key].nil?
                  arr.push(format(row[key.downcase]))
                else
                  arr.push(format(row[key]))
                end
              end
            end
          end
          rcsv << arr
        end
      end
    }

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