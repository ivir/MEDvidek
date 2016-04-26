require 'yaml'
require_relative './module_med.rb'

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'

class ArbitrMED
  def initialize
    loadModules
    @data = nil
    @memory = Hash.new()
    @output = nil
  end
  #nacteni veskerych dostupnych modulu
  def loadModules()
    Dir[(__dir__) + '/modules/*.rb'].each {|file| require file }
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

    emodule = eval(mod[0] +".new")
    emodule.properties(@memory,mod[1])
    execModule(emodule.preprocessing(@memory))
    emodule.execute(@memory)
    execModule(emodule.postprocessing(@memory))

  end

  def loadRecipe (recipe)
    @data = YAML.load_file(recipe)
  end

  def loadRecipeText(recipe)
    @data = YAML.load(recipe)
  end

  def cook()
    @data.each { |execMod|
      execModule(execMod)
    }
  end

  def getOutput()
    return if @memory["output"].nil?
    logger.debug @memory["output"]
    @memory[@memory["output"]]
  end
end