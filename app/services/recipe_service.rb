class RecipeService
  def self.fetch_recipes(ingredient_ids:, category_id:, page:, per_page:)
    recipes = Recipe.all

    if ingredient_ids.present?
      recipes = recipes.by_ingredients(ingredient_ids).ordered_by_matched_ingredients(ingredient_ids)
    end

    if category_id.present?
      recipes = recipes.by_category(category_id)
    end

    recipes.paginate(page: page, per_page: per_page)
  end
end
