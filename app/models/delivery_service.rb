class DeliveryService < ApplicationRecord
  has_many :orders
  validates :name, uniqueness: true
end
