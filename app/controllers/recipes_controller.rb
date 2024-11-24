class RecipesController < ApplicationController
  def index
    ingredient_ids = if params[:ingredient_names].present?
      Ingredient.where(name: params[:ingredient_names].split(",")).pluck(:id)
    else
      []
    end

    page = params[:page] || "1"
    @recipes = RecipeService.fetch_recipes(
      ingredient_ids: ingredient_ids,
      page: page.to_i,
      per_page: 10
    )

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
