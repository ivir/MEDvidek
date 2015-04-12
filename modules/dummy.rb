require_relative('../module_med')

class Dummy < ModuleMED

  def properties(fdata)
    printf "Spusten\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat\n"
  end

end