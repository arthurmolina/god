Types::ClientType = GraphQL::ObjectType.define do
 name "ClientType"

 field :id, types.ID
 field :name, types.String
 field :address, types.String

 field :orders do
   type Types::OrderType
   description "orders made by this client"
   resolve ->(client, args, context){
     client.orders
   }
 end
end
