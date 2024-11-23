require 'rails_helper'

RSpec.describe RecipesRepository, type: :repository do
  describe '.find_by_ingredients' do
    let!(:tomato) { create(:ingredient, name: 'Tomato') }
    let!(:onion) { create(:ingredient, name: 'Onion') }
    let!(:recipe1) { create(:recipe) }  # Una receta que tiene al menos un ingrediente
    let!(:recipe2) { create(:recipe) }  # Otra receta con diferentes ingredientes

    context 'when no ingredients are provided' do
      it 'returns no recipes' do
        result = RecipesRepository.find_by_ingredients([], page: 1, per_page: 10)
        expect(result).to be_empty
      end
    end

    context 'when some ingredients match' do
      it 'returns recipes that contain the given ingredients' do
        result = RecipesRepository.find_by_ingredients(['Tomato'], page: 1, per_page: 10)
        
        expect(result).to include(recipe1)  # Esperamos que recipe1 sea parte de los resultados
        expect(result).not_to include(recipe2)  # recipe2 no tiene 'Tomato'
      end
    end

    context 'when ingredients do not match any recipes' do
      it 'returns no recipes' do
        result = RecipesRepository.find_by_ingredients(['Garlic'], page: 1, per_page: 10)
        expect(result).to be_empty
      end
    end

    context 'when multiple ingredients match' do
      it 'orders recipes by the number of matching ingredients' do
        create(:recipe_ingredient, recipe: recipe1, ingredient: onion)  # Agregamos más ingredientes a recipe1

        result = RecipesRepository.find_by_ingredients(['Tomato', 'Onion'], page: 1, per_page: 10)
        
        # Verificamos que recipe1 (que tiene ambos ingredientes) aparezca antes que recipe2 (que solo tiene un ingrediente)
        expect(result.first).to eq(recipe1)
        expect(result.second).to eq(recipe2)
      end
    end

    context 'pagination' do
      it 'returns the correct number of recipes per page' do
        create_list(:recipe, 15)  # Creamos 15 recetas

        result = RecipesRepository.find_by_ingredients(['Tomato'], page: 1, per_page: 10)

        expect(result.size).to eq(10)  # Debemos obtener 10 recetas en la primera página
        expect(result.current_page).to eq(1)
        expect(result.total_pages).to be > 1
      end
    end
  end
end
