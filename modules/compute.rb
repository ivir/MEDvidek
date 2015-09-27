require_relative('../module_med')

#Compute vypocte hodnotu pro konkretni radek a ulozi jej nazpet.
class Compute < ModuleMED

  def properties(memory,fdata)
    printf "Spusten Compute\n"
    print fdata
    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
    @calculate = fdata["calculate"]
  end

  #compute rozseka retezec pomoci operatoru (+-*/%) a nasledne promenne nahradi za variantu pro pristup do datasetu pro provedeni dane operace.
  def compute(fdata)

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