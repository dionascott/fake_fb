class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :invited_id
      t.integer :invited_by_id
      t.boolean :status, default: false

      t.timestamps
    end
    add_index :relationships, :invited_id
    add_index :relationships, :invited_by_id
    add_index :relationships, :status
    add_index :relationships, [:invited_by_id, :invited_id], unique: true
  end
end
