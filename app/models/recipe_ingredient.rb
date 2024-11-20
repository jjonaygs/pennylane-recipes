class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :ingredient, presence: true
  validates :recipe, presence: true
end
