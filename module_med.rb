class ModuleMED

  def initialize
    @enviroment = "cz"
  end

  def inputData(fdata)
    # vstupni data pro zpracovani
  end

  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani
  end

  def properties(memory,fdata)
    #povinne
    # navraci seznam podporovanych vstupu a vystupu

    #povinne musi byt definovana polozka memory["output"]uvadejici kde je ulozen vystup
    #memory["output"] = nil
  end

  def status(fdata)
    #vysledek posledni operace

  end

  def preprocessing(fdata)
    # navraci recept, ktery se ma pouzit na data pred vstupem
  end

  def postprocessing(fdata)
    # navraci recept, ktery se ma pouzit na data po zpracovani timto modulem
  end

  def execute(fdata)
    # povinne
    # spusteni zpracovani
  end

  def test(fdata)
    # navraci výsledek interniho testu, 0 - OK, >0 - chyba
    return 0
  end
  private

    def format(input)
      if @enviroment.nil?
        case input
          when Float then
            num = input.to_s
            return num
          when BigDecimal then
            num = input.to_s('F')
            return num
          when NilClass then
            return ""
          else
            #print "#{input.class} s daty #{input}\n"
            return input.to_s
        end
      else
        if (@enviroment == "cz")
          case input
            when Float then
              num = input.to_s
              return num.tr!(".",",")
            when BigDecimal then
              num = input.to_s('F')
              return num.tr!(".",",")
            when NilClass then
              return ""
            else
              #print "#{input.class} s daty #{input}\n"
              return input.to_s
          end
        end

      end
    end
end