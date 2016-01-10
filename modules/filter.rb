require_relative('../module_med')

class Filter < ModuleMED

  def properties(memory,fdata)
    printf "Spusten filtr\n"
    print fdata
    ''
  end

  def execute(fdata)
    printf "Jdu pracovat s filtrem\n"
  end

end