class BatchReport < ApplicationRecord
  belongs_to :purchase_channel
  self.primary_key = 'id'

  enum status: Batch.statuses
end
