require './arbitrMED.rb'

app = ArbitrMED.new

nacist = ARGV[0]

if( (!nacist.nil?) && (File.exists?(nacist)))
  app.loadRecipe nacist
else
  app.loadRecipeText nacist
end

app.cook
