class User < ApplicationRecord
  require 'json_web_token.rb'

  has_secure_password
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  belongs_to :purchase_channel

  def token(user = nil)
    if user = self
      JsonWebToken.encode(user_id: user.id)
    else
      nil
    end
  end
  
end
