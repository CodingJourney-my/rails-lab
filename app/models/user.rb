class User < ApplicationRecord
  has_many :artiles

  has_secure_password

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true
  validates :password, presence: true
end
