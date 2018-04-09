class BatchReport < ApplicationRecord
  belongs_to :purchase_channel
  belongs_to :delivery_service
  self.primary_key = 'id'

  enum status: Batch.statuses
end
