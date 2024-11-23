class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :category, presence: true, allow_blank: true
  validates :author, presence: true, allow_blank: true
  validates :ratings, presence: true, allow_blank: true
  validates :image, presence: true, allow_blank: true
  validates :cuisine, presence: true, allow_blank: true

  scope :by_category, ->(category_id) {
    where(category: category_id) if category_id.present?
  }

  # Ejemplo de otros scopes necesarios:
  scope :by_ingredients, ->(ingredient_ids) {
    joins(:recipe_ingredients)
      .where(recipe_ingredients: { ingredient_id: ingredient_ids })
      .distinct
  }

  scope :ordered_by_matched_ingredients, ->(ingredient_ids) {
    select(
      "recipes.*, COUNT(recipe_ingredients.id) AS matched_ingredients_count"
    ).joins(:recipe_ingredients)
     .where(recipe_ingredients: { ingredient_id: ingredient_ids })
     .group("recipes.id")
     .order("matched_ingredients_count DESC")
  }

end
