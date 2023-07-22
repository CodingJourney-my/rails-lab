class CreateUserVideoViews < ActiveRecord::Migration[7.0]
  def change
    create_table :user_video_views do |t|
      t.references :user
      t.references :video
      t.decimal :play_time, precision: 10, scale: 3, default: 0

      t.timestamps
    end
  end
end
