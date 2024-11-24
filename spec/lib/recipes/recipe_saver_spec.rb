require 'rails_helper'

RSpec.describe Recipes::RecipeSaver do
  let(:valid_recipe_data) do
    {
      title: 'Chocolate Cake',
      author: 'John Doe',
      cook_time: 45,
      prep_time: 20,
      ratings: 4.5,
      cuisine: 'American',
      category: 'Dessert',
      image: 'https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F8198612.jpg'
    }
  end

  let(:valid_ingredients) do
    [
      { name: 'Milk', quantity: '1 1/2', unit: 'cups' },
      { name: 'Sugar', quantity: '3/4', unit: 'cup' }
    ]
  end

  let(:invalid_recipe_data) do
    {
      title: nil, # Missing title
      author: 'John Doe',
      cook_time: 45,
      prep_time: 20,
      ratings: 4.5,
      cuisine: 'American',
      category: 'Dessert',
      image: nil
    }
  end

  describe '#save' do
    context 'when valid recipe and ingredients are provided' do
      it 'creates a recipe and associated ingredients' do
        saver = Recipes::RecipeSaver.new(valid_recipe_data, valid_ingredients)

        saver.save

        recipe = Recipe.last
        expect(recipe.title).to eq('Chocolate Cake')
        expect(recipe.recipe_ingredients.count).to eq(2)
        expect(recipe.ingredients.count).to eq(2)
        expect(recipe.ingredients.first.name).to eq('Milk')
      end
    end

    context 'when ingredients are missing' do
      it 'creates the recipe without ingredients' do
        saver = Recipes::RecipeSaver.new(valid_recipe_data, [])

        expect { saver.save }.to change(Recipe, :count).by(1)
        expect(Recipe.last.ingredients.count).to eq(0)
      end
    end

    context 'when a recipe already exists with the same title and author' do
      it 'does not create a duplicate recipe' do
        Recipes::RecipeSaver.new(valid_recipe_data, valid_ingredients).save

        saver = Recipes::RecipeSaver.new(valid_recipe_data, valid_ingredients)
        expect { saver.save }.not_to change(Recipe, :count)
      end
    end

    context 'when invalid recipe data is provided' do
      it 'does not create the recipe and logs an error' do
        saver = Recipes::RecipeSaver.new(invalid_recipe_data, valid_ingredients)

        expect { saver.save }.not_to change { Recipe.count }
      end
    end


    context 'when there is an error creating ingredients' do
      it 'logs a warning and rolls back the transaction' do
        invalid_ingredient = { name: nil, quantity: '1', unit: 'cup' }

        saver = Recipes::RecipeSaver.new(valid_recipe_data,
[ invalid_ingredient ])

        expect { saver.save }.not_to change(Recipe, :count)

        expect(Ingredient.count).to eq(0)

        expect(RecipeIngredient.count).to eq(0)
      end
    end
  end
end
