module AuthenticationHelper
  def get_authentication_token
    @user ||= FactoryBot.create(:user)
    command = AuthenticateUser.call(@user.email, @user.password)
    command.success? ? command.result[:token] : false
  end
end