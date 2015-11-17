require_relative('../module_med')
require_relative('../libs/dentaku/lib/dentaku')

#Compute vypocte hodnotu pro konkretni radek a ulozi jej nazpet.
class Compute < ModuleMED

  def properties(memory,fdata)
    printf "Spusten Compute\n"
    #print fdata
    print memory
    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
    @calculate = fdata["calculate"]
    @calculator = Dentaku::Calculator.new

    #nahrajeme promenne do pameti pro moznost nahrady
    memory.each_key { |key,value|
      printf "Nahravam" + key.to_s + "=" + value.to_s
      @calculator.store(key,value)
    }
  end

  #compute rozseka retezec pomoci operatoru (+-*/%) a nasledne promenne nahradi za variantu pro pristup do datasetu pro provedeni dane operace.
  def compute(fdata)

    @destination = @calculator.evaluate(@calculate)
  end
  
  def execute(fdata)
    printf "Jdu pracovat\n"
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
