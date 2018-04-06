class Mutations::ProduceBatch < GraphQL::Function
  type Types::BatchType # especificação do tipo de retorno

  def call(obj, args, context)
    return { errors: 'Batch not found' } unless batch = Batch.where(reference: args[:reference]).first # busca o User a ser alterado

    if batch.update_attributes(status: 2)
      { batch: batch }
    else
      { batch: batch.errors.to_a }
    end
  end
end