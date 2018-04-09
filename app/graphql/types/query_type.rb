Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  
  #field :node, GraphQL::Relay::Node.field
  field :nodes, GraphQL::Relay::Node.plural_field
  
  # PLURALS ###################################################################
  connection :clients, Types::ClientType.connection_type, function: Resolvers::ClientsSearch
  connection :orders,  Types::OrderType.connection_type,  function: Resolvers::OrdersSearch
  connection :batches, Types::BatchType.connection_type,  function: Resolvers::BatchesSearch  
  connection :users,   Types::UserType.connection_type,   function: Resolvers::UsersSearch

  connection :purchaseChannels, Types::PurchaseChannelType.connection_type do
    resolve ->(o, a, c) { PurchaseChannel.all }
  end

  connection :deliveryServices, Types::DeliveryServiceType.connection_type do
    resolve ->(o, a, c) { DeliveryService.all }
  end

  # SINGULAR ##################################################################
  field :myself, Types::UserType do
    description "My information"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present?
        ctx[:current_user]
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
      }
  end

  field :batch, Types::OrderType do
    argument :id, !types.ID
    description "Batch of Orders"
    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['production', 'transportation', 'admin'])
        Batch.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :order, Types::OrderType do
    argument :id, !types.ID
    description "Order"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'production', 'transportation', 'admin'])
        Order.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :client, Types::ClientType do
    argument :id, !types.ID
    description "Client"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'transportation', 'admin'])
        Client.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :user, Types::UserType do
    argument :id, !types.ID
    description "User"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['admin'])
        User.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :purchaseChannel, Types::PurchaseChannelType do
    argument :id, !types.ID
    description "Purchase Channels"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'admin'])
        PurchaseChannel.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :deliveryService, Types::DeliveryServiceType do
    argument :id, !types.ID
    description "Delivery Service"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'transportation', 'admin'])
        DeliveryService.where(id: args[:id]).first
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end
end
