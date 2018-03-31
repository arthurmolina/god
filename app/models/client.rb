class Client < ApplicationRecord
  has_many :orders
  validates :name, uniqueness: true
end
