class CreateLikes < ActiveRecord::Migration[5.1]
  def change
    create_table :likes do |t|
      t.boolean :liked
      t.references :post, foreign_key: true
      t.integer :liker_id, foreign_key: true

      t.timestamps
    end
  end
end
