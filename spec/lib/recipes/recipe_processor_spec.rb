require 'rails_helper'

RSpec.describe Recipes::RecipeProcessor, type: :model do
  let(:valid_recipe_data) do
    {
      title: "Golden Sweet Cornbread",
      cook_time: 25,
      prep_time: 10,
      ingredients: [ "1 cup flour", "1 cup cornmeal", "⅔ cup sugar" ],
      ratings: 4.74,
      cuisine: "",
      category: "Cornbread",
      author: "bluegirl",
      image: "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F43%2F2021%2F10%2F26%2Fcornbread-1.jpg"
    }
  end

  describe '#process' do
    context 'when ingredients are present' do
      it 'calls IngredientExtractor#extract with the correct ingredients' do
      extractor_double = double("IngredientExtractor", extract: [
        { quantity: "1", unit: "cup", name: "flour" },
        { quantity: "1", unit: "cup", name: "cornmeal" },
        { quantity: "⅔", unit: "cup", name: "sugar" }
      ])
      allow(Ingredients::IngredientExtractor).to receive(:new).and_return(extractor_double)

      recipe_processor = Recipes::RecipeProcessor.new(valid_recipe_data)
      recipe_processor.process

      expect(Ingredients::IngredientExtractor).to have_received(:new).with(valid_recipe_data[:ingredients])
      expect(extractor_double).to have_received(:extract)
    end


      it 'calls RecipeSaver#save with the correct extracted ingredients' do
        saver_double = double("RecipeSaver", save: true)
        allow(Recipes::RecipeSaver).to receive(:new).and_return(saver_double)

        recipe_processor = Recipes::RecipeProcessor.new(valid_recipe_data)
        recipe_processor.process

        expect(Recipes::RecipeSaver).to have_received(:new).with(
          valid_recipe_data, [ { quantity: "1", unit: "cup", name: "Flour" },
                               { quantity: "1", unit: "cup", name: "Cornmeal" },
                               { quantity: "⅔", unit: "cup", name: "Sugar" } ])
        expect(saver_double).to have_received(:save)
      end
    end

    context 'when ingredients are missing' do
      it 'calls RecipeSaver#save with an empty ingredients list' do
        recipe_data_without_ingredients = valid_recipe_data.merge(ingredients: [])

        saver_double = double("RecipeSaver", save: true)
        allow(Recipes::RecipeSaver).to receive(:new).and_return(saver_double)

        recipe_processor = Recipes::RecipeProcessor.new(recipe_data_without_ingredients)
        recipe_processor.process

        expect(Recipes::RecipeSaver).to have_received(:new).with(
          recipe_data_without_ingredients, [])
        expect(saver_double).to have_received(:save)
      end
    end
  end
end
