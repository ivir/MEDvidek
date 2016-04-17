require_relative('../module_med')
require 'net/http'

class Print < ModuleMED

  def properties(memory,fdata)
    @what = memory[fdata["source"]]
    @source = fdata["source"]
  end

  def execute(fdata)
    return if @what.nil?
    print @what
  end

end

class Ping < ModuleMED

  def properties(memory,fdata)
    @ping = fdata["url"]
  end

  def execute(fdata)
    uri = URI(@ping)
    Net::HTTP.get(uri)
  end

end

module Format
  def convert(data)
      data.gsub!(/^".*"$/,'')

      if data =~ /^[+-]?\d+\s*$/
        return (Integer(data));
      end
      if data =~ /^[+-]?\d+\s*\d*\.\d+[e+\-\d]*\s*$/
        return (Float(data));
      end
      if data =~ /^[+-]?\d+[\S\s]*\d*,?\d+[e+\-\d]*\s*$/
        #pouzita ceska forma zapisu
        data.gsub!(/[^+\-0-9,e]/,'')
        data.tr!(',','.')
        return (Float(data))
      end
      #nebylo rozpoznano co to jest -> ulozime jak to je
      String(data)
  end
end