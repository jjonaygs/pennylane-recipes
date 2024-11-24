require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    let!(:ingredient1) { Ingredient.create!(name: "Carrot") }
    let!(:ingredient2) { Ingredient.create!(name: "Potato") }
    let!(:recipe) { Recipe.create!(title: "Vegetable Soup", category: "Soup", author: "John Doe", ratings: 5, image: "image_url", cuisine: "Global") }

    # Crear recipe_ingredients
    before do
      recipe.ingredients << ingredient1
      recipe.ingredients << ingredient2
    end

    describe 'dependent destroy on recipe_ingredients' do
      it 'destroys associated recipe_ingredients when the recipe is destroyed' do
        expect { recipe.destroy }.to change { RecipeIngredient.count }.by(-2)  # Se eliminan los 2 recipe_ingredients
      end

      it 'does not destroy associated ingredients when the recipe is destroyed' do
        expect { recipe.destroy }.not_to change { Ingredient.count }  # Los ingredientes no se eliminan
      end
    end
  end
end
