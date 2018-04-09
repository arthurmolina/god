class User < ApplicationRecord
  require 'json_web_token.rb'

  has_secure_password
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  belongs_to :purchase_channel
  enum role: {stores: 1, production: 2, transportation:3, admin: 4}

  def token(user = nil)
    if user = self
      JsonWebToken.encode(user_id: user.id)
    else
      nil
    end
  end
  
end
