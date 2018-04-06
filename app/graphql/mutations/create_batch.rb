class Mutations::CreateBatch < GraphQL::Function
  argument :reference, types.String
  argument :purchase_channel_id, types.Int
  argument :order_references, types[types.String]

  type Types::BatchType # especificação do tipo de retorno

  def call(obj, args, context)
    Batch.create!(args.to_h)
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  end
end