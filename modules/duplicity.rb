require_relative('../module_med')
require 'dentaku'
# Trida pro reseni duplicitnich polozek v seznamu a moznych operaci s daty
#
class Duplicity < ModuleMED

  def properties(memory,fdata)
    #printf "Spusten filtr\n"

    @source = fdata["source"]
    @destination = fdata["store"]
    @condition = fdata["compare"]
    @operation = fdata["operation"]


    @what = memory[@source]

    unless (@source.eql? @destination) || (@destination.nil?)
      memory[@destination] = @what.clone
      @what = memory[@destination]
    end

    @memory = memory
    @memory["output"] = @what


  end

  def execute(fdata)
    #printf "Jdu pracovat s filtrem\n"
    @what.sort(@condition)
    
  end

end