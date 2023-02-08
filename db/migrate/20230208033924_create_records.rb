class CreateRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :records do |t|
      t.text :content, null: false
      t.date :recorded_on, null: false

      t.index :recorded_on, unique: true
      t.timestamps
    end
  end
end
