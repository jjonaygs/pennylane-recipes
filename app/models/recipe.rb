class Recipe < ApplicationRecord
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  validates :title, presence: true, uniqueness: true
  validates :category, presence: true, allow_blank: true
  validates :author, presence: true, allow_blank: true
  validates :ratings, presence: true, allow_blank: true
  validates :image, presence: true, allow_blank: true
  validates :cuisine, presence: true, allow_blank: true
end
