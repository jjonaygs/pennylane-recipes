module Recipes
  class RecipeSaver
    def initialize(recipe_data, ingredients)
      @recipe_data = recipe_data
      @ingredients = ingredients
    end

    def save
      ActiveRecord::Base.transaction do
        image_url = decode_image_url(@recipe_data[:image])

        puts @recipe_data
        recipe = Recipe.create!(
          title: @recipe_data[:title],
          author: @recipe_data[:author],
          cook_time: @recipe_data[:cook_time],
          prep_time: @recipe_data[:prep_time],
          ratings: @recipe_data[:ratings],
          cuisine: @recipe_data[:cuisine],
          category: @recipe_data[:category],
          image: image_url
        )
        Rails.logger.info("Recipe created successfully:#{recipe.title} by #{recipe.author}")

        if @ingredients.present?
          @ingredients.each do |ingredient_data|
            ingredient = Ingredient.find_or_create_by(name: ingredient_data[:name])

            begin
              RecipeIngredient.create!(
                recipe: recipe,
                ingredient: ingredient,
                quantity: ingredient_data[:quantity],
                unit: ingredient_data[:unit]
              )
            rescue ActiveRecord::RecordNotUnique => e
              Rails.logger.warn("Could not create RecipeIngredient due to conflict: #{e.message}")
              raise ActiveRecord::Rollback
            rescue ActiveRecord::RecordInvalid => e
              Rails.logger.warn("Validation failed for RecipeIngredient: #{e.message}")
              raise ActiveRecord::Rollback
            rescue ActiveRecord::NotNullViolation => e
              Rails.logger.error("Failed to create RecipeIngredient due to null value: #{e.message}")
              raise ActiveRecord::Rollback
            end
          end
        else
          Rails.logger.warn("No ingredients to save for recipe #{@recipe_data[:title]}.")
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Failed to create recipe: #{e.message}")
      nil
    rescue ActiveRecord::Rollback
      Rails.logger.error("Transaction rolled back due to an error in creating RecipeIngredient.")
      nil
    end

    private

      def decode_image_url(url)
        return nil if url.nil?

        if url.start_with?("https://imagesvc.meredithcorp.io")
          decoded_url = URI.decode_www_form_component(URI.parse(url).query.split("=").last)
          decoded_url
        else
          url
        end
      end
  end
end