require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  before(:all) do
    @ingredient1 = Ingredient.create!(name: "Carrot")
    @ingredient2 = Ingredient.create!(name: "Caramel")
    @ingredient3 = Ingredient.create!(name: "Apple")
  end

  after(:all) do
    Ingredient.delete_all
  end

  describe 'callbacks' do
    it 'normalizes the name before saving' do
      ingredient = Ingredient.create!(name: "  PEAR   ")
      expect(ingredient.name).to eq("Pear")
    end
  end

  describe 'destroy' do
    let!(:recipe) { Recipe.create!(title: "Soup") }

    let!(:ingredient_without_recipe) { Ingredient.create!(name: "Lettuce") }
    let!(:recipe_ingredient) { RecipeIngredient.create!(ingredient: @ingredient1, recipe: recipe) }

    context 'when the ingredient is associated with a recipe_ingredient' do
      it 'does not allow the ingredient to be destroyed' do
        expect { @ingredient1.destroy }.to raise_error(ActiveRecord::InvalidForeignKey)
      end
    end

    context 'when the ingredient is not associated with a recipe_ingredient' do
      it 'allows the ingredient to be destroyed' do
        expect { ingredient_without_recipe.destroy }.to change { Ingredient.count }.by(-1)
      end
    end
  end

  describe '.search_by_name' do
    it 'returns ingredients matching the query when the query is part of the name' do
      result = Ingredient.search_by_name("car")
      expect(result).to match_array([ @ingredient1, @ingredient2 ])
    end

    it 'returns ingredients matching the query when the query is case insensitive' do
      result = Ingredient.search_by_name("Car")
      expect(result).to match_array([ @ingredient1, @ingredient2 ])
    end

    it 'returns an empty array when no matches are found' do
      result = Ingredient.search_by_name("Banana")
      expect(result).to be_empty
    end

    it 'returns an empty array when the query is blank' do
      result = Ingredient.search_by_name("")
      expect(result).to be_empty
    end

    it 'returns an empty array when the query is nil' do
      result = Ingredient.search_by_name(nil)
      expect(result).to be_empty
    end
  end
end
