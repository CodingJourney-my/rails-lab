class Record < ApplicationRecord
  validates :content, presence: true
  validates :recorded_on, presence: true, uniqueness: true
end