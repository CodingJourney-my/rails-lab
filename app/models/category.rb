class Category < ApplicationRecord
  # Doc: https://github.com/stefankroes/ancestry?tab=readme-ov-file#tree-navigation
  has_ancestry ancestry_format: :materialized_path2, orphan_strategy: :restrict, cache_depth: true, counter_cache: true

  enum status: { inactive: 0, active: 1 }
  enum public_status: { draft: 0, published: 1 }

  validates :name, presence: true
end
