# app/controllers/ingredients_controller.rb
class IngredientsController < ApplicationController
  def search
    query = params[:q]
    
    # Buscar los ingredientes que coincidan con la consulta (query)
    # Aquí puedes adaptar la lógica de búsqueda según tu modelo de datos
    ingredients = Ingredient.where('name LIKE ?', "%#{query}%").pluck(:name)

    # Devolver la cantidad total de ingredientes y los ingredientes encontrados
    render json: {
      total_count: ingredients.length,
      items: ingredients
    }
  end
end
