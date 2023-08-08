class Article::Video < ApplicationRecord
  # user_video_viewsは、userモデルとarticle::videoモデルの中間テーブルです。
  has_many :user_video_views, dependent: :destroy
  validates :uid, presence: true
end
