require 'rails_helper'

RSpec.describe Order, type: :model do
  it { should validate_presence_of(:reference) }
  it { should belong_to(:purchase_channel) }
  it { should belong_to(:delivery_service) }
  it { should belong_to(:client) }
end
