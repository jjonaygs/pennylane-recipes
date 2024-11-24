require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'associations' do
    let!(:ingredient1) { Ingredient.create!(name: "Carrot") }
    let!(:ingredient2) { Ingredient.create!(name: "Potato") }
    let!(:ingredient3) { Ingredient.create!(name: "Onion") }
    let!(:recipe1) { Recipe.create!(title: "Vegetable Soup", category: "Soup", author: "John Doe", ratings: 5, image: "image_url", cuisine: "Global") }
    let!(:recipe2) { Recipe.create!(title: "Carrot Salad", category: "Salad", author: "Jane Doe", ratings: 4, image: "image_url", cuisine: "Global") }
    let!(:recipe3) { Recipe.create!(title: "Potato Mash", category: "Side", author: "Alex Doe", ratings: 5, image: "image_url", cuisine: "Global") }
    let!(:recipe4) { Recipe.create!(title: "Onion Rings", category: "Appetizer", author: "Chris Doe", ratings: 4, image: "image_url", cuisine: "Global") }

    before do
      # Associate ingredients with recipes
      recipe1.ingredients << ingredient1
      recipe1.ingredients << ingredient2
      recipe1.ingredients << ingredient3 # recipe1 has 3 ingredients
      recipe2.ingredients << ingredient1
      recipe2.ingredients << ingredient2 # recipe2 has 2 ingredients
      recipe3.ingredients << ingredient1 # recipe3 has 1 ingredient
      # recipe4 has no matching ingredients
    end

    describe 'dependent destroy on recipe_ingredients' do
      it 'destroys associated recipe_ingredients when the recipe is destroyed' do
        expect { recipe1.destroy }.to change { RecipeIngredient.count }.by(-3)
      end

      it 'does not destroy associated ingredients when the recipe is destroyed' do
        expect { recipe1.destroy }.not_to change { Ingredient.count }
      end
    end
  end

  describe 'scopes' do
    let!(:ingredient1) { Ingredient.create!(name: "Carrot") }
    let!(:ingredient2) { Ingredient.create!(name: "Potato") }
    let!(:ingredient3) { Ingredient.create!(name: "Onion") }
    let!(:ingredient4) { Ingredient.create!(name: "Peper") }
    let!(:recipe1) { Recipe.create!(title: "Vegetable Soup", category: "Soup", author: "John Doe", ratings: 5, image: "image_url", cuisine: "Global") }
    let!(:recipe2) { Recipe.create!(title: "Carrot Salad", category: "Salad", author: "Jane Doe", ratings: 4, image: "image_url", cuisine: "Global") }
    let!(:recipe3) { Recipe.create!(title: "Potato Mash", category: "Side", author: "Alex Doe", ratings: 5, image: "image_url", cuisine: "Global") }
    let!(:recipe4) { Recipe.create!(title: "Onion Rings", category: "Appetizer", author: "Chris Doe", ratings: 4, image: "image_url", cuisine: "Global") }

    before do
      # Associate ingredients with recipes
      recipe1.ingredients << ingredient1
      recipe1.ingredients << ingredient2
      recipe1.ingredients << ingredient3 # recipe1 has 3 ingredients
      recipe2.ingredients << ingredient1
      recipe2.ingredients << ingredient2 # recipe2 has 2 ingredients
      recipe3.ingredients << ingredient1 # recipe3 has 1 ingredient
      # recipe4 has no matching ingredients
    end

    describe '.ordered_by_matched_ingredients' do
      it 'orders recipes by the number of matched ingredients in descending order' do
        result = Recipe.by_matched_ingredients([ingredient1.id, ingredient2.id, ingredient3.id])
        expect(result).to eq([recipe1, recipe2, recipe3])
      end

      it 'returns an empty array when no recipes match the ingredients' do
        result = Recipe.by_matched_ingredients([ingredient4.id])
        expect(result).to be_empty
      end

      it 'returns an empty array when no ingredients are passed' do
        result = Recipe.by_matched_ingredients([])
        expect(result).to be_empty
      end
    end
  end
end
