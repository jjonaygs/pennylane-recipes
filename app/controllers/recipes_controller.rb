class RecipesController < ApplicationController
  def index
    # Convertimos los nombres de ingredientes en IDs
    ingredient_ids = if params[:ingredient_names].present?
                       Ingredient.where(name: params[:ingredient_names].split(',')).pluck(:id)
                     else
                       []
                     end

    # Inicializamos el servicio con los parámetros necesarios
    @recipes = RecipeService.fetch_recipes(
      ingredient_ids: ingredient_ids,
      category_id: params[:category_id], # Puede ser nil
      page: params[:page] || 1,
      per_page: 10
    )

    respond_to do |format|
      format.html # Renderiza HTML normalmente
      format.turbo_stream # Renderiza respuesta para Turbo Streams
    end
  end
end
