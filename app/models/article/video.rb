class Article::Video < ApplicationRecord
  validates :uid, presence: true
end
