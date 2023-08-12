class User::Profile < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  enum gender: {
    male: 0,
    female: 1,
    non_binary: 2,
    prefer_not_to_say: 3
  }
end
