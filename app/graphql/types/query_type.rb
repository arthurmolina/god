Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  
  field :order, Types::OrderType do
    argument :id, !types.ID
    description "Order"
    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) {
      Order.where(id: args[:id]).first
    }
  end

  field :allOrders, types[Types::OrderType] do
    argument :id, types.ID
    description "Orders"

    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) {
      Order.all
    }
  end

  field :purchaseChannel, Types::PurchaseChannelType do
    argument :id, !types.ID
    description "Purchase Channels"
    must_be [1,2,3,4]
    
    resolve ->(obj, args, ctx) {
      PurchaseChannel.where(id: args[:id]).first
    }
  end
end
