class Mutations::UpdateOrder < GraphQL::Function
  argument :id, types.ID
  argument :reference, types.String
  argument :total_value, types.Float
  argument :line_items, types.String

  type Types::OrderType # especificação do tipo de retorno

  def call(obj, args, context)
    order = Order.where(reference: args[:reference]).first
    order = Order.where(id: args[:id]).first if order.blank?
    raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'admin'])
    raise "Order not found" if order.blank?
    order.update_attributes!(args.to_h)

  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  rescue Exception => e
    GraphQL::ExecutionError.new("Error: #{e.to_s}")
  end
end

