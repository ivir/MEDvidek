require 'yaml'
require './module_med.rb'

gem 'sqlite3', '~> 1.3.10'
require 'sqlite3'

class ArbitrMED
  def initialize
    loadModules
    @data = nil
    @memory = Hash.new()
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
    return if mod.nil?
    print mod[0]
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
end