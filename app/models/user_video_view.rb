class UserVideoView < ApplicationRecord
  belongs_to :user
  belongs_to :video, class_name: 'Article::Video'
end
