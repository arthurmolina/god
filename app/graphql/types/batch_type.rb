Types::BatchType = GraphQL::ObjectType.define do
 name "BatchType"

 field :id, types.ID
 field :reference, types.String
 field :status, types.String

 field :orders do
   type Types::OrderType
   description "Orders associated to this batch"
   resolve ->(batch, args, context){
     batch.orders
   }
 end
end
