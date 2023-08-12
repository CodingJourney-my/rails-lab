class CreateUserProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.references :user
      t.string :name
      t.integer :gender

      t.timestamps
    end
  end
end
