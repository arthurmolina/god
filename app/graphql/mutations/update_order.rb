class Mutations::UpdateOrder < GraphQL::Function
  argument :total_value, types.Float
  argument :line_items, types.String

  type Types::OrderType # especificação do tipo de retorno

  def call(obj, args, context)
    return { errors: 'Order not found' } unless order = Order.where(reference: args[:reference]).first # busca o User a ser alterado

    if order.update_attributes(args.to_h)
      { order: order }
    else
      { order: order.errors.to_a }
    end
  end
end