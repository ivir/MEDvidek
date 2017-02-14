require_relative('../module_med')
require 'dentaku'

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
    @memory = memory

    @calculator = Dentaku::Calculator.new

    memory.each_key { |key,value|
      @calculator.store(key,value) if value.is_a?(Integer) || value.is_a?(Float)
    }

    if @source.nil?
      data = 1
      @calculator.store("SIZE",data)
    else
      @calculator.store("SIZE",@source.length)
    end

  end

  #compute rozseka retezec pomoci operatoru (+-*/%) a nasledne promenne nahradi za variantu pro pristup do datasetu pro provedeni dane operace.
  def compute(fdata)
    #print "Jdu spocitat: " + @calculate.to_s + "\n"
    @calculator.evaluate(@calculate)
  end
  
  def execute(fdata)
    #printf "Jdu pracovat\n"
    temp = Hash.new

    if @what.nil?
      #nepocitame neco v datasetu -> navratime cislo do promenne
      @memory["output"] = @destination

      result = compute(nil)
      if result
        result = result.round(@precision) unless @precision.nil?
      end
      @memory.store(@destination, result) unless @destination.nil?
      return
    end

    #vysledkem bude dataset -> navracime dataset
    @memory["output"] = @source


    depend = @calculator.dependencies(@calculate) #zjisteni zavislosti

    @what.each do |value|
      #print value
      @calculator.clear()
      #nahrajeme do pameti kalkulatoru pouze pozadovane promenne
      depend.each do |variable|
        if value[variable].nil?
          if @memory[variable].nil?
            @calculator.store(variable,0)
          else
            @calculator.store(variable,@memory[variable])
          end
        else
          @calculator.store(variable,value[variable])
        end
      end
    #-----
      result = compute(nil)
      if result
        result = result.round(@precision) unless @precision.nil?
        #print "Vyšlo #{result}\n"
        #result = @minimum if (!(@minimum.nil?) && (result < @minimum))
        #result = @maximum if (!(@maximum.nil?) && (result > @maximum))
      end

      temp.store(@destination,result)

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
    #printf "Jdu pracovat Agregate\n"
    first = true

    if @what.nil?
      #nepocitame neco v datasetu -> navratime cislo do promenne
      @memory["output"] = @destination

      result = compute(nil)
      if result
        result = result.round(@precision) unless @precision.nil?
      end
      @memory.store(@destination,result) unless @destination.nil?
      return
    end

    #vysledkem bude result
    @memory["output"] = @destination

    @what.each do |value|
      #print value
      @calculator.clear()
      #nahrajeme do pameti kalkulatoru pouze pozadovane promenne
      depend = @calculator.dependencies(@calculate)
      depend.each do |variable|
        if value[variable].nil?
          if @memory[variable].nil?
            @calculator.store(variable,0)
          else
            @calculator.store(variable,@memory[variable])
          end
        else
          @calculator.store(variable,value[variable])
        end
      end
      #----
      if first
        @store = compute(nil)
        first = false
      else
        @store = cumul(@operation,@store,compute(nil)) #pripocteme hodnotu
      end

    end

  end

  def cumul(oper,value_a,value_b)
    value_a = 0 if value_a.nil?
    value_b = 0 if value_b.nil?

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
              oper = "+" if oper.nil?
              eval("value_a " + oper + " value_b")
          end
    out
  end

end
