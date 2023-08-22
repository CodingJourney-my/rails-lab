class User < ApplicationRecord
  has_many :articles
  has_one :profile, class_name: 'User::Profile', foreign_key: 'user_id'

  delegate :name, to: :profile, allow_nil: true

  has_secure_password

  # validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true
  validates :password, presence: true
end
