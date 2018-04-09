class Mutations::SignUp < GraphQL::Function
  argument :name, types.String
  argument :email, types.String
  argument :password, types.String
  argument :password_confirmation, types.String
  argument :role, types.Int
  argument :purchase_channel_id, types.Int

  type Types::UserType

  def call(obj, args, context)
    user = User.new(args.to_h)
    if user.save!
      user
    else
      raise "Invalid email or password"
    end

  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  rescue Exception => e
    GraphQL::ExecutionError.new(e.to_s)
  end
end
