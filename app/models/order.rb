class Order < ApplicationRecord
  belongs_to :purchase_channel
  belongs_to :client
  belongs_to :delivery_service
  belongs_to :batch, optional: true
end
