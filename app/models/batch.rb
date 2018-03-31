class Batch < ApplicationRecord
  has_many :orders
  belongs_to :purchase_channel
  validates :reference, uniqueness: true
  enum status: {production: 2, closing: 3, sent: 4}
end
