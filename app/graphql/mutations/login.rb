class Mutations::Login < GraphQL::Function
  argument :name, types.String
  argument :email, types.String
  argument :password, types.String
  
  type Types::UserType

  def call(obj, args, context)
    command = AuthenticateUser.call(args[:email], args[:password])

    if command.success?
      command.result[:user]
    else
      raise "Invalid email or password"
    end
  rescue Exception => e
    GraphQL::ExecutionError.new(e.to_s)
  end

end
