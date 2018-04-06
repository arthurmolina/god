Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  
  #field :node, GraphQL::Relay::Node.field
  field :nodes, GraphQL::Relay::Node.plural_field
  
  # PLURALS ###################################################################
  connection :clients, Types::ClientType.connection_type, function: Resolvers::ClientsSearch
  connection :orders,  Types::OrderType.connection_type,  function: Resolvers::OrdersSearch
  connection :batches, Types::BatchType.connection_type,  function: Resolvers::BatchesSearch
  connection :users,   Types::UserType.connection_type,   function: Resolvers::UsersSearch do
    must_be [1,2,3,4]
  end

  connection :purchaseChannels, Types::PurchaseChannelType.connection_type do
    must_be [1,2,3,4]
    resolve ->(o, a, c) { PurchaseChannel.all }
  end

  connection :deliveryServices, Types::DeliveryServiceType.connection_type do
    must_be [1,2,3,4]
    resolve ->(o, a, c) { DeliveryService.all }
  end

  # SINGULAR ##################################################################
  field :batch, Types::OrderType do
    argument :id, !types.ID
    description "Batch of Orders"
    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) { Batch.where(id: args[:id]).first }
  end

  field :order, Types::OrderType do
    argument :id, !types.ID
    description "Order"
    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) { Order.where(id: args[:id]).first }
  end

  field :client, Types::ClientType do
    argument :id, !types.ID
    description "Client"
    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) { Client.where(id: args[:id]).first }
  end

  field :user, Types::UserType do
    argument :id, !types.ID
    description "User"
    must_be [1,2,3,4]

    resolve ->(obj, args, ctx) { User.where(id: args[:id]).first }
  end

  field :purchaseChannel, Types::PurchaseChannelType do
    argument :id, !types.ID
    description "Purchase Channels"
    must_be [1,2,3,4]
    
    resolve ->(obj, args, ctx) { PurchaseChannel.where(id: args[:id]).first }
  end

  field :deliveryService, Types::DeliveryServiceType do
    argument :id, !types.ID
    description "Delivery Service"
    must_be [1,2,3,4]
    
    resolve ->(obj, args, ctx) { DeliveryService.where(id: args[:id]).first }
  end
end
