require 'yaml'
require_relative './module_med.rb'

class ArbitrMED
  def initialize
    loadModules
    @data = nil
    @memory = Hash.new()
    @output = nil
    @memory["PATH"] = ""
  end
  #nacteni veskerych dostupnych modulu
  def loadModules()
    Dir[(__dir__) + '/modules/*.rb'].each {|file| require file }

    @moduly = Module.constants.map() {

    }
  end

  def loadModule(mod)
    # nacteni dat
    require './modules/' + (mod).downcase + ".rb"
  end

  def execModule(mod)
    # Spusteni zpracovani dat
    #mod[0] - modul co se bude spoustet
    #mod[1] - YAML parametry
    return if mod.nil?

    mod.each { |modu,value|
      if Object.const_defined?(modu)
        #emodule = eval(modu + ".new")
        emodule = Object.const_get(modu).new
        if emodule.is_a?(ModuleMED)
          emodule.properties(@memory,value)
          execModule(emodule.preprocessing(@memory))
          emodule.execute(@memory)
          execModule(emodule.postprocessing(@memory))
        end

      else
        #neznamy modul -> nic nedelame
      end
    }


  end

  def loadRecipe (recipe)
    @data = YAML.load_file(recipe)
  end

  def loadRecipeText(recipe)
    @data = YAML.load(recipe)
  end

  def loadRecipeYAML(recipe)
    @data = recipe.clone
  end

  def cook()
    @data.each { |execMod|
      #puts execMod
      execModule(execMod)
    }
  end

  def path(path)
    @memory["PATH"] = path

  end

  def getOutput()
    return if @memory["output"].nil?
    #logger.debug @memory["output"]
    @memory[@memory["output"]]
  end
end