require './arbitrMED.rb'

app = ArbitrMED.new

app.loadRecipe "./recipes/cook_numbers.yml"
app.cook
