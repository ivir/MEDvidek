require_relative('../module_med')
require_relative('../libs/dentaku/lib/dentaku')

#Compute vypocte hodnotu pro konkretni radek a ulozi jej nazpet.
class Compute < ModuleMED

  def properties(memory,fdata)
    #printf "\nSpusten Compute\n"
    #print fdata
    #print memory
    @what = memory[fdata["source"]]
    @source = fdata["source"]
    @destination = fdata["store"]
    @store = memory[@destination]
    @calculate = fdata["calculate"]
    @minimum = fdata["minimum"]
    @maximum = fdata["maximum"]
    @precision = fdata["precision"]
    @calculator = Dentaku::Calculator.new

    memory.each_key { |key,value|
      @calculator.store(key,value) if value.is_a?(Integer) || value.is_a?(Float)
    }
    @calculator.store("SIZE",@source.length)
  end

  #compute rozseka retezec pomoci operatoru (+-*/%) a nasledne promenne nahradi za variantu pro pristup do datasetu pro provedeni dane operace.
  def compute(fdata)
    #print "Jdu spocitat: " + @calculate.to_s + "\n"
    @calculator.evaluate(@calculate)
  end
  
  def execute(fdata)
    #printf "Jdu pracovat\n"
    temp = Hash.new
    @what.each do |value|
      #print value
      value.each_pair { |key,val|
        #print "K: #{key} V: #{val} #{val.class}\n"
        @calculator.store(key,val)
      }
      hodnota = compute(nil)
      unless hodnota.nil?
        hodnota = hodnota.round(@precision) unless @precision.nil?
        #print "Vyšlo #{hodnota}\n"
        #hodnota = @minimum if (!(@minimum.nil?) && (hodnota < @minimum))
        #hodnota = @maximum if (!(@maximum.nil?) && (hodnota > @maximum))
      end

      temp.store(@destination,hodnota)

      value.merge!(temp)

    end

    @what.add_column(@destination,0) unless @what.verify_column(@destination)
  end

end

#Agregate provede agregaci celeho sloupce v predanem datasetu
class Agregate < Compute

  def properties(memory,fdata)
    @operation = fdata["operation"]
    super(memory,fdata)
  end

  def execute(fdata)
    printf "Jdu pracovat Agregate\n"
    first = true
    @what.each do |value|
      #print value
      value.each_pair { |key,val|
        #print "K: #{key} V: #{val} \n"
        @calculator.store(key,val)
      }
      unless first
        @store = cumul(@operation,@store,compute(nil))
      else
        @store = compute(nil)
        first = false
      end

      #print @store
      #print "\n"

    end

  end

  def cumul(oper,value_a,value_b)
    out = case oper
            when "+"
              value_a + value_b
            when "-"
              value_a - value_b
            when "*"
              value_a * value_b
            when "/"
              value_a / value_b
            when "%"
              value_a % value_b
            else
              eval("value_a " + oper + " value_b")
          end
    out
  end

end
