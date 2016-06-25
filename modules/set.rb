require_relative('../module_med')
require 'net/imap'
require 'mail'

class Set < ModuleMED

  def properties(memory,fdata)
    @memory = memory

  end

  def execute(fdata)
    # zpracuji se fdata
    fdata.each_pair {|key,value|
      @memory[key] = value
    }
  end

end