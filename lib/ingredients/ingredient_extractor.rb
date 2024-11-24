module Ingredients
  class IngredientExtractor
    def initialize(ingredients)
      @ingredients = ingredients || []
    end

    def extract
      return [] unless @ingredients.present?

      @ingredients.map do |ingredient_string|
        parse_ingredient(ingredient_string)
      end
    end

    private

      def parse_ingredient(ingredient_string)
        regex = /
        ^(?:\s*(?<quantity>(?:\d+\s?)?[\½\¾\⅓\⅔\⅕\¼\¾]|\d+\/\d+|\d+\s\d+\/\d+|\d+)?\s*)?
        (?<unit>cups?|teaspoons?|tablespoons?|grams?|g|kg|ounces?|oz|ml|
        liters?|pound|lbs?|pinch|dash|packages?|cans?)?\s*(?<name>.+)$
      /ix

        match = ingredient_string.match(regex)

        if match
          {
            quantity: match[:quantity],
            unit: match[:unit],
            name: match[:name].strip.downcase.titleize
          }
        else
          Rails.logger.warn("Ingredient string could not be parsed: #{ingredient_string}")
          nil
        end
      end
  end
end
