class RecipeService
  def self.fetch_recipes(ingredient_ids:, category_id:, page:, per_page:)
    recipes = Recipe.all

    # Filtrar por ingredientes solo si ingredient_ids no está vacío o nulo
    if ingredient_ids.present?
      recipes = recipes.by_ingredients(ingredient_ids).ordered_by_matched_ingredients(ingredient_ids)
    end

    # Filtrar por categoría solo si category_id está presente
    if category_id.present?
      recipes = recipes.by_category(category_id)
    end

    # Paginación
    recipes.paginate(page: page, per_page: per_page)
  end
end
