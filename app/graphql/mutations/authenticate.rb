class Mutations::Authenticate < GraphQL::Function
  argument :authentication_token, types.String
  
  type Types::UserType

  def call(obj, args, ctx)
    ctx[:current_user]
  end

end
