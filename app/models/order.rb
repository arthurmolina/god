class Order < ApplicationRecord
  belongs_to :purchase_channel
  belongs_to :client
  belongs_to :delivery_service
  belongs_to :batch, optional: true
  
  validates_presence_of :reference
  validates :reference, uniqueness: true, allow_nil: false, allow_blank: false
  validates :status, :purchase_channel_id, :status, :delivery_service_id, presence: true, allow_nil: false, allow_blank: false

  attr_reader :status

  def status
    batch&.status || 1
  end
end
