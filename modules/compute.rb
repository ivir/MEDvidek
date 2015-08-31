require_relative('../module_med')

class Compute < ModuleMED

  def properties(memory,fdata)
    printf "Spusten Compute\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat\n"
  end

end

class Agregate < ModuleMED

  def properties(memory,fdata)
    printf "Spusten Agregate\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat Agregate\n"
  end

end