class Batch < ApplicationRecord
  has_many      :orders
  belongs_to    :purchase_channel, optional: true
  validates     :reference, uniqueness: true
  validate      :same_purchase_channel, :status_change
  before_create :define_purchase_channel_and_status

  enum status: {production: 2, closing: 3, sent: 4}

  private

  def define_purchase_channel_and_status
    self.purchase_channel_id = self.orders.first.purchase_channel_id
    self.status = 2 # Created a batch to production.
  end

  def same_purchase_channel
    purchase = self.orders.collect(&:purchase_channel_id).uniq
    if purchase.count > 1
      errors.add(:purchase_channel_id, "orders with more than one different purchase channel")
      return false
    end

    if !purchase_channel_id.nil? && purchase_channel_id != purchase[0]
      errors.add(:purchase_channel_id, "must be the same as the orders")
      return false
    end
  end

  def status_change
    if !self.id.nil? && self.status_changed? 
      s_was = Batch.statuses[self.status_was]
      s_now = Batch.statuses[self.status]

      if (s_was > s_now)
        errors.add(:status, "cannot go step back.")
        return false
      end
      if ((s_was == 2 && s_now != 3) || 
         (s_was == 3 && s_now != 4))
        errors.add(:status, "can only be changed to the next level (#{
          self.status_was == 2 ? 'production to closing' : 'closing to sent'}.")
        return false
      end
    end
  end

end
