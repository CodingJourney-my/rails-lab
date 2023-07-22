class Article < ApplicationRecord
  belongs_to :user
  has_one :survey, class_name: "Article::Survey"
  has_many :videos, class_name: "Article::Video"
end
