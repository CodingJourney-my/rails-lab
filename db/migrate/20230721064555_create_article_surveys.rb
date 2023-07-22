class CreateArticleSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :article_surveys do |t|
      t.string :name
      t.text   :uid
      t.references :article

      t.timestamps
    end
  end
end
