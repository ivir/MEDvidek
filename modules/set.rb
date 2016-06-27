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
    vari = fdata["variable"]
    valu = fdata["value"]
    @memory[vari] = valu unless vari.nil?

  end

end