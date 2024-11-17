class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :cook_time
      t.integer :prep_time
      t.string :category
      t.string :author
      t.float :ratings
      t.string :image

      t.timestamps
    end
  end
end
