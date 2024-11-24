class IngredientsController < ApplicationController
  def search
    query = params[:q]
        ingredients = Ingredient.where("name LIKE ?", "%#{query}%").pluck(:name)

    render json: {
      total_count: ingredients.length,
      items: ingredients
    }
  end
end
