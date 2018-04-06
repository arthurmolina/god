Types::OrderType = GraphQL::ObjectType.define do
 name "OrderType"

 #field :id, types.ID
 field :reference, types.ID
 field :total_value, types.Float
 field :line_items, types.String, "Line items"
 field :status, types.String, "Status of the order"
 #field :created_at, types.Timestamp

 field :purchase_channel do
   type Types::PurchaseChannelType
   description "Purchase Channel of this order"
   resolve ->(order, args, context){
     order.purchase_channel
   }
 end

 field :client do
   type Types::ClientType
   description "Client of this order"
   resolve ->(order, args, context){
     order.client
   }
 end

 field :delivery_service do
   type Types::DeliveryServiceType
   description "Delivery service of this order"
   resolve ->(order, args, context){
     order.delivery_service
   }
 end

 field :batch do
   type Types::BatchType
   description "Batch of this order"
   resolve ->(order, args, context){
     order.batch
   }
 end
end
