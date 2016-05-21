require_relative('../module_med')
require_relative('../db_storage')

class ExportJson < ModuleMED
  def initialize
    @db = Dataset.new

  end
  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["source"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @file = fdata["file"]
    @ping = fdata["ping"]
    @columns = fdata["columns"]

    # @memory["output"]

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
      if @columns.nil? then
        row.each_pair do |key,value|
          td.push("#{format(key)}: #{format(value)}")
        end
      else
        # chce jen cast
        @columns.each do |col|
          unless col.class == Hash
            td.push("#{format(col)}: #{format(row[col])}")
          else
            col.each_pair do |key,value|
              td.push("#{format(value)}: #{format(row[key])}")
            end
          end
        end
      end

      data +=td.join(",")
      data += "}"
      datas.push(data)
    end
    data = "[#{datas.join(",")}]"
    File.write(@file,data)
  end

  private

    def format(input)
      case input
        when Float then
          return input.to_s
        when BigDecimal then
          return input.to_s('F')
        when String then
          return "\"#{input.to_s}\""
        when nil then
          return "\"#{input.to_s}\""
        else
          return input.to_s
      end
    end

end

class ImportJson < ModuleMED
  def initialize
    require "json"
  end
  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
    @store = fdata["store"]
    @memory = memory
    #@store = Dataset.new if @store.nil?
    @file = fdata["file"]
    @ping = fdata["ping"]
    # @memory["output"]

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
    unless @file.nil?
      ds = JSON.parse(File.open(@file))
    else
      ds = JSON.parse(@source)
    end
  end

  private
  
  def format(input)
    case input
      when Float then
        return input.to_s
      when BigDecimal then
        return input.to_s('F')
      when String then
        return "\"#{input.to_s}\""
      when nil then
        return "\"#{input.to_s}\""
      else
        return input.to_s
    end
  end

end