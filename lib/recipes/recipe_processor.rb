module Recipes
  class RecipeProcessor
    def initialize(recipe_data)
      @recipe_data = recipe_data
    end

    def process
      ingredients = @recipe_data[:ingredients]

      if ingredients.present?
        extracted_ingredients = Ingredients::IngredientExtractor.new(ingredients).extract
        RecipeSaver.new(@recipe_data, extracted_ingredients).save
      else
        puts "Warning: No ingredients found for recipe #{@recipe_data[:title]}."
        Rails.logger.warn("Warning: No ingredients found for recipe #{@recipe_data[:title]}.")
        RecipeSaver.new(@recipe_data, []).save
      end
    end
  end
end
