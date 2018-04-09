class Mutations::ChangeStatusBatch < GraphQL::Function
  type Types::BatchType # especificação do tipo de retorno
  
  BatchStatus = GraphQL::EnumType.define do
    name 'BatchStatus'

    value 'closing'
    value 'sent'
  end

  argument :id, types.ID
  argument :reference, types.String
  argument :status, !BatchStatus

  def call(obj, args, context)
    batch = Batch.where(reference: args[:reference]).first
    batch = Batch.where(id: args[:id]).first if batch.blank?
    raise "Batch not found" if batch.blank?

    batch.update! status: args[:status]
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  rescue Exception => e
    GraphQL::ExecutionError.new("Error: #{e.to_s}")
  end

end