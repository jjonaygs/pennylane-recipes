class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient

  # Validaciones para asegurarse de que 'ingredient' y 'recipe' estén presentes
  validates :ingredient, presence: true
  validates :recipe, presence: true

  # Validaciones para quantity y unit (puedes ajustar según tus necesidades)
  validates :quantity, presence: true, numericality: { allow_nil: true }  # O ajusta el tipo de validación
  validates :unit, presence: true, allow_nil: true
end
