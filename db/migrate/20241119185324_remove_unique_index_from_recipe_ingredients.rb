class RemoveUniqueIndexFromRecipeIngredients < ActiveRecord::Migration[8.0]
  def change
    remove_index :recipe_ingredients, column: [ :recipe_id, :ingredient_id ]
  end
end
