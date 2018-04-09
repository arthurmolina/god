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

  field :report, types[Types::BatchReportType] do
    Months = GraphQL::EnumType.define do
      name 'Months'

      value 'Jan'
      value 'Fev'
      value 'Mar'
      value 'Apr'
      value 'May'
      value 'Jun'
      value 'Jul'
      value 'Aug'
      value 'Sep'
      value 'Oct'
      value 'Nov'
      value 'Dec'
    end

    argument :year, !types.Int
    argument :month, Months
    argument :purchase_channel_id, types.Int
    description "Financial Report"

    resolve -> (obj, args, ctx) {
      begin
        months = ['All', 'Jan', 'Fev', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        batchReport = BatchReport.where(purchase_channel_id: args[:purchase_channel_id], status: 'sent').where("extract(year from updated_at) = ?", args[:year])
        batchReport = batchReport.where("extract(month from updated_at) = ?", months.index(args[:month])) if args[:month].present?
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end

  field :reportSummary, types[Types::BatchReportPerMonthType] do
    argument :year, !types.Int
    argument :purchase_channel_agregated, types.Bool, default_value: false
    description "Financial Report Summary"

    resolve -> (obj, args, ctx) {
      begin
        batchReport = BatchReport.
          where(status: 'sent').where("extract(year from updated_at) = ?", args[:year]).
          group(:purchase_channel_id, "extract(month from updated_at)").
          order("extract(month from updated_at)").
          select("extract(month from updated_at) as month, purchase_channel_id, sum(total_value) total_value, sum(orders) orders")
      rescue Exception => e
        GraphQL::ExecutionError.new("Error: #{e.to_s}")
      end
    }
  end
end
