class ChangeForeignKeysOnRecipeIngredients < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :recipe_ingredients, :recipes
    remove_foreign_key :recipe_ingredients, :ingredients

    add_foreign_key :recipe_ingredients, :recipes, on_delete: :cascade
    add_foreign_key :recipe_ingredients, :ingredients, on_delete: :restrict
  end
end
