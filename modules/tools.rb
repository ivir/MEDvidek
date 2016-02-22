require_relative('../module_med')

class Print < ModuleMED

  def properties(memory,fdata)
    printf "Spusten\n"
    print fdata
    @what = memory[fdata["source"]]
    @source = fdata["source"]
  end

  def execute(fdata)
    return if @what.nil?
    printf "Printing:\n"
    print @what
    printf "Jdu pracovat\n"
  end

end