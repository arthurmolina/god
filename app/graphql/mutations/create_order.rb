class Mutations::CreateOrder < GraphQL::Function
  argument :reference, types.String
  argument :purchase_channel_id, types.Int
  argument :client_id, types.Int
  argument :delivery_service_id, types.Int
  argument :total_value, types.Float
  argument :line_items, types.String

  type Types::OrderType # especificação do tipo de retorno

  def call(obj, args, context)
    raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'admin'])
    Order.create!(args.to_h)
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end