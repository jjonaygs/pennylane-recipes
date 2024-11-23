class RecipesService
  def find_recipes(ingredient_names: [], category_id: nil, page: 1, per_page: 10)
    # Obtener los IDs de los ingredientes basados en los nombres proporcionados
    ingredient_ids = nil
    if ingredient_names.present?
      ingredient_ids = Ingredient.where(name: ingredient_names).pluck(:id)
    end

    # Realizar la consulta filtrada
    recipes = filter_recipes_by_ingredients_and_category(ingredient_ids, category_id)

    # Paginación
    recipes.paginate(page: page, per_page: per_page)
  end

  def filter_recipes_by_ingredients_and_category(ingredient_ids, category_id)
    # Base de la consulta
    query = Recipe.joins(:recipe_ingredients)

    # Filtrar por categoría si se proporciona
    query = query.where(category: category_id) if category_id.present?

    # Filtrar por ingredientes si se proporcionan
    if ingredient_ids.present? && ingredient_ids.any?
      query = query.where('recipe_ingredients.ingredient_id IN (?)', ingredient_ids)
      
      # Agregar las agregaciones para calcular los ingredientes coincidentes
      select_sentence = <<-SQL
      recipes.*, 
      SUM(CASE 
            WHEN recipe_ingredients.ingredient_id IN (#{ingredient_ids.join(',')}) 
            THEN 1 
            ELSE 0 
          END) AS matched_ingredients
    SQL

      query = query.select(select_sentence)
                   .group('recipes.id')
                   .order('matched_ingredients DESC')
    end
    
    # Devolver la consulta
    query.distinct
  end
end
