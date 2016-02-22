require_relative('../module_med')
require_relative('../libs/dentaku/lib/dentaku')

class Filter < ModuleMED

  def properties(memory,fdata)
    printf "Spusten filtr\n"

    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
    @store = memory[@destination]
    @condition = fdata["condition"]
    @calculator = Dentaku::Calculator.new

    memory.each_key { |key,value|
      @calculator.store(key,value) if value.is_a?(Integer) || value.is_a?(Float)
    }

  end

  def execute(fdata)
    printf "Jdu pracovat s filtrem\n"
    @what.delete_if do |value|
      #print value
      value.each_pair { |key,val|
        print "K: #{key} V: #{val} #{val.class}\n"
        @calculator.store(key,val)
      }
      print "#{@condition} \n"
      out = @calculator.evaluate(@condition)

      out

    end
    @what

  end
end