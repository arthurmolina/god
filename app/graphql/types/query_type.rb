Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  
  field :order, Types::OrderType do
    argument :id, types.ID
    description "Orders"

    resolve ->(obj, args, ctx) {
      Order.where(id: args[:id]).first
    }
  end

  field :allOrder, Types::OrderType do
    argument :id, types.ID
    description "Orders"

    resolve ->(obj, args, ctx) {
      Order.all
    }
  end

  field :purchase_channel, Types::PurchaseChannelType do
    argument :id, types.ID
    description "Purchase Channels"

    resolve ->(obj, args, ctx) {
      PurchaseChannel.where(id: args[:id]).first
    }
  end
end
