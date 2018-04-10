class Mutations::CreateBatch < GraphQL::Function
  argument :reference, types.String
  argument :order_references, types[types.String]

  type Types::BatchType # especificação do tipo de retorno

  def call(obj, args, ctx)
    raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['production', 'admin'])
    orders = Order.where(reference: args['order_references'])
    Batch.create!(reference: args['reference'], orders: orders)
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end