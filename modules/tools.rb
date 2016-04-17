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