class Article < ApplicationRecord
  belongs_to :user
  has_one :survey, class_name: "Article::Survey"
end
