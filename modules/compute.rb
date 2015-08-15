require_relative('../module_med')

class Compute < ModuleMED

  def properties(memory,fdata)
    printf "Spusten\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat\n"
  end

end

class Agregate < ModuleMED

  def properties(memory,fdata)
    printf "Spusten\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat\n"
  end

end