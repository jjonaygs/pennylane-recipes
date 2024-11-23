class Ingredient < ApplicationRecord
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  validates :name, presence: true, uniqueness: true

  before_save :normalize_name

  def self.search_by_name(query)
    where('name LIKE ?', "%#{query}%")
  end

  private

    def normalize_name
      self.name = name.strip.downcase.titleize
    end
end
