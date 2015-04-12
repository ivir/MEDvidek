require './arbitrMED.rb'

app = ArbitrMED.new

app.loadRecipe "./recipes/dummy.yml"
app.cook
