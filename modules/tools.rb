require_relative('../module_med')

class Print < ModuleMED

  def properties(memory,fdata)
    printf "Spusten\n"
    print fdata
    @what = memory[fdata["source"]]
  end

  def execute(fdata)
    printf @what
    printf "Jdu pracovat\n"
  end

end