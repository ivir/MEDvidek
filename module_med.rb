class ModuleMED

  def inputData(fdata)
    # vstupni data pro zpracovani
  end

  def inputRecipe(fdata)
    # nacteni parametru pro zpracovani
  end

  def properties(memory,fdata)
    # navraci seznam podporovanych vstupu a vystupu
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
    # spusteni zpracovani
  end
end