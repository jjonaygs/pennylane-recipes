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

RSpec.describe Recipes::RecipeSaver, type: :model do
  describe "#decode_image_url" do
    let(:recipe_saver) { Recipes::RecipeSaver.new({}, []) }

    context "when the URL is nil" do
      it "returns nil" do
        expect(recipe_saver.send(:decode_image_url, nil)).to be_nil
      end
    end

    context "when the URL is not from Meredith" do
      it "returns the original URL" do
        url = "https://example.com/image.jpg"
        decoded_url = recipe_saver.send(:decode_image_url, url)
        expect(decoded_url).to eq(url)
      end
    end

    context "when the URL is a valid Meredith URL with an encoded image URL" do
      it "decodes the URL correctly" do
        encoded_url = "https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fstatic.onecms.io%2Fwp-content%2Fuploads%2Fsites%2F43%2F2021%2F10%2F26%2Fcornbread-1.jpg"
        decoded_url = recipe_saver.send(:decode_image_url, encoded_url)
        expected_url = "https://static.onecms.io/wp-content/uploads/sites/43/2021/10/26/cornbread-1.jpg"
        expect(decoded_url).to eq(expected_url)
      end
    end
  end
end
