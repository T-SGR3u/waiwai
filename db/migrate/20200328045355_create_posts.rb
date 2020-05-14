class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :name,    null: false
      t.text :review,    null: false
      t.float :score,    null: false
      t.text :link    

      t.timestamps
    end
  end
end
