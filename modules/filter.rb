require_relative('../module_med')
require "dentaku"

class Filter < ModuleMED

  def properties(memory,fdata)
    #printf "Spusten filtr\n"

    @source = fdata["source"]
    @destination = fdata["store"]
    @condition = fdata["condition"]
    @calculator = Dentaku::Calculator.new

    @what = memory[@source]

    unless (@source.eql? @destination) || (@destination.nil?)
      memory[@destination] = @what.clone
      @what = memory[@destination]
    end

    @memory = memory
    @memory["output"] = @what

    memory.each_key { |key,value|
      @calculator.store(key,value) if value.is_a?(Integer) || value.is_a?(Float)
    }

  end

  def execute(fdata)
    #printf "Jdu pracovat s filtrem\n"
    res = @what.delete_if do |value|
      #print value
      value.each_pair { |key,val|
        #print "K: #{key} V: #{val} #{val.class}\n"
        @calculator.store(key,val) unless val.nil?
      }
      #print "#{@condition} \n"
      out = @calculator.evaluate(@condition)

      !out

    end
    res
  end
end