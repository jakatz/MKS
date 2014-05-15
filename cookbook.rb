class Cookbook
	attr_accessor :title
	attr_reader :recipes

	def initialize(title)
		@title = title
		@recipes = []
	end

	def add_recipe(recipe)
		@recipes << recipe
		puts "Added a recipe to the collection: #{recipe.title}"
	end

	def recipe_titles
		@recipes.each do |recipe|
			puts recipe.title
		end
	end

	def recipe_ingredients
		@recipes.each do |recipe|
			puts "These are the ingredients for #{recipe.title}: #{recipe.ingredients}"
		end
	end

	def print_cookbook
		@recipes.each do |recipe|
			recipe.print_recipe
		end
	end
end

class Recipe
	attr_accessor :title, :ingredients, :steps

	def initialize(title, ingredients, steps)
		@title = title
		@ingredients = ingredients
		@steps = steps
	end

	def print_recipe
		puts "Recipe: #{self.title}\nIngredients: #{self.ingredients.join(", ")}\nSteps:\n#{self.list_steps}"
	end

	def list_steps
		@steps.each_with_index do |item, index|
			puts "#{index + 1}. #{item}"
		end
	end
end