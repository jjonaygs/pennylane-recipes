class RecipesController < ApplicationController
  def index
    @recipes = RecipesService.new.find_recipes(
      ingredient_names: params[:ingredient_names].present? ? params[:ingredient_names].split(',') : [],
      category_id: params[:category_id], # Si no se envía, será nil y no se aplicará ningún filtro por categoría
      page: params[:page] || 1,
      per_page: 10
    )

    respond_to do |format|
      format.html # Normal HTML
      format.turbo_stream
    end
  end
end
