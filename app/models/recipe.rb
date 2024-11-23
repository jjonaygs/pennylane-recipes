class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :category, presence: true, allow_blank: true
  validates :author, presence: true, allow_blank: true
  validates :ratings, presence: true, allow_blank: true
  validates :image, presence: true, allow_blank: true
  validates :cuisine, presence: true, allow_blank: true

  # Scope para filtrar recetas por ingredientes
  scope :by_ingredients, ->(ingredient_ids) {
    joins(:recipe_ingredients)
      .where(recipe_ingredients: { ingredient_id: ingredient_ids })
      .distinct
  }

  # Scope para filtrar recetas por categoría
  scope :by_category, ->(category_id) {
    where(category: category_id) if category_id.present?
  }

  scope :with_ingredient_counts, ->(ingredient_ids) {
  select_sentence = "recipes.*, 
  SUM(CASE 
        WHEN recipe_ingredients.ingredient_id IN (#{ingredient_ids.join(',')}) 
        THEN 1 
        ELSE 0 
      END) AS matched_ingredients"
  
  select(select_sentence)
  .joins(:recipe_ingredients)
  .where('recipe_ingredients.ingredient_id IN (?)', ingredient_ids)
  .group('recipes.id')
  .order('matched_ingredients DESC')
}
  
  


end
