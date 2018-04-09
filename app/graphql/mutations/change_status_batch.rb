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

  def call(obj, args, ctx)
    batch = Batch.where(reference: args[:reference]).first
    batch = Batch.where(id: args[:id]).first if batch.blank?
    raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['production', 'transportation', 'admin'])
    raise "Batch not found" if batch.blank?

    batch.update! status: args[:status]
    batch
  rescue ActiveRecord::RecordInvalid => e
    GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
  rescue Exception => e
    GraphQL::ExecutionError.new(e.to_s)
  end

end
