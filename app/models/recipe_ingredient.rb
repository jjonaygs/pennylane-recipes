class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :recipe_id, uniqueness: { scope: :ingredient_id, message: "Should have a unique ingredient per recipe" }
end
