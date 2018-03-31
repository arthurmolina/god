class Order < ApplicationRecord
  belongs_to :purchase_channel
  belongs_to :client
  belongs_to :delivery_service
  belongs_to :batch, optional: true

  validates :reference, uniqueness: true
  attr_reader :status

  def status
    batch&.status || 1
  end
end
