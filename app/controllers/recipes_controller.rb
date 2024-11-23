class RecipesController < ApplicationController
  def index
    ingredient_ids = if params[:ingredient_names].present?
                       Ingredient.where(name: params[:ingredient_names].split(',')).pluck(:id)
                     else
                       []
                     end

    @recipes = RecipeService.fetch_recipes(
      ingredient_ids: ingredient_ids,
      category_id: params[:category_id],
      page: params[:page] || 1,
      per_page: 10
    )

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
