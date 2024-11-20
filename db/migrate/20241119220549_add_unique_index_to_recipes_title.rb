class AddUniqueIndexToRecipesTitle < ActiveRecord::Migration[8.0]
  def change
    add_index :recipes, :title, unique: true
  end
end
