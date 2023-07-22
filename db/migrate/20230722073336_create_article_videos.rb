class CreateArticleVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :article_videos do |t|
      t.text :uid, null: false
      t.references :article
      t.timestamps
    end
  end
end
