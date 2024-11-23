class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  validates :ingredient, presence: true
  validates :recipe, presence: true

  validates :quantity, presence: true, numericality: { allow_nil: true }  # O ajusta el tipo de validación
  validates :unit, presence: true, allow_nil: true
end
