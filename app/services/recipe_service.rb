class RecipeService
  def self.fetch_recipes(ingredient_ids:, page:, per_page:)
    recipes = Recipe.all

    if ingredient_ids.present?
      recipes = recipes.by_matched_ingredients(ingredient_ids)
    end

    recipes.paginate(page: page, per_page: per_page)
  end
end
