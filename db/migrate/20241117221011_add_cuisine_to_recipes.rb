class AddCuisineToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :cuisine, :string
  end
end
