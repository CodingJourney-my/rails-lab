class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :note
      t.string :ancestry, collation: 'utf8mb4_bin', null: false
      t.integer :public_status, default: 1, null: false
      t.integer :status, limit: 1, default: 1, null: false
      t.integer :ancestry_depth, default: 0
      t.integer :children_count, default: 0

      t.timestamps
    end
    add_index :categories, :ancestry
  end
end
