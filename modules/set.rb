require_relative('../module_med')

class SetValue < ModuleMED

  def properties(memory,fdata)
    @memory = memory
    vari = fdata["variable"]
    valu = fdata["value"]
    @memory[vari] = valu
    p "Zapisuji do #{vari}=#{valu}"

  end

  def execute(fdata)
    # zpracuji se fdata
    p fdata
    vari = fdata["variable"]
    valu = fdata["value"]
    @memory[vari] = valu
    p "Zapisuji do #{vari}=#{valu}"

  end

end