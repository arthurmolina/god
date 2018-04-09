require 'rails_helper'

RSpec.describe Batch, type: :model do
  it { should validate_presence_of(:reference) }
  it { should validate_presence_of(:status) }
  #it { should have_many(:orders).conditions(purchase_channel_id: purchase_channel_id) }
end
