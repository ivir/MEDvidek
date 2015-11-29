require_relative('../module_med')
require_relative('../libs/dentaku/lib/dentaku')

#Compute vypocte hodnotu pro konkretni radek a ulozi jej nazpet.
class Compute < ModuleMED

  def properties(memory,fdata)
    printf "\nSpusten Compute\n"
    #print fdata
    #print memory
    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
    @calculate = fdata["calculate"]
    @calculator = Dentaku::Calculator.new

    memory.each_key { |key,value|
      @calculator.store(key,value) if value.is_a?(Integer) || value.is_a?(Float)
    }
  end

  #compute rozseka retezec pomoci operatoru (+-*/%) a nasledne promenne nahradi za variantu pro pristup do datasetu pro provedeni dane operace.
  def compute(fdata)
    print "Jdu spocitat: " + @calculate.to_s + "\n"
    @calculator.evaluate(@calculate)
  end
  
  def execute(fdata)
    printf "Jdu pracovat\n"
    temp = Hash.new
    @what.each do |value|
      print value
      value.each_pair { |key,val|
        print "K: #{key} V: #{val} \n"
        @calculator.store(key,val)
      }
      temp.store(@destination,compute(nil))
      value.merge!(temp)
    end

    print @what.to_s
  end

end

#Agregate provede agregaci celeho sloupce v predanem datasetu
class Agregate < ModuleMED

  def properties(memory,fdata)
    printf "Spusten Agregate\n"
    print fdata
    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
  end

  def execute(fdata)
    printf "Jdu pracovat Agregate\n"
  end

end
