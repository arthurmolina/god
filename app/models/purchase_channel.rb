class PurchaseChannel < ApplicationRecord
  has_many :orders
  has_many :batches
  validates :name, uniqueness: true
end
