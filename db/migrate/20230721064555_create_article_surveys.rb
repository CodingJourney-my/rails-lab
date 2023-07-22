class CreateArticleSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :article_surveys do |t|
      t.string :name
      t.text   :form_id
      t.references :article

      t.timestamps
    end
  end
end
