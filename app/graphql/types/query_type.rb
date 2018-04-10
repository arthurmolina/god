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
        GraphQL::ExecutionError.new(e.to_s)
      end
      }
  end

  field :batch, Types::OrderType do
    argument :id, types.ID
    argument :reference, types.String
    description "Batch of Orders"
    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['production', 'transportation', 'admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'Batch'
          Batch.where(id: record_id ).first
        else
          Batch.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :order, Types::OrderType do
    argument :id, types.ID
    argument :reference, types.String
    description "Order"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'production', 'transportation', 'admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'Order'
          Order.where(id: record_id ).first
        else
          Order.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :client, Types::ClientType do
    argument :id, types.ID
    argument :reference, types.String
    description "Client"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'transportation', 'admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'Client'
          Client.where(id: record_id ).first
        else
          Client.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :user, Types::UserType do
    argument :id, types.ID
    argument :reference, types.String
    description "User"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'User'
          User.where(id: record_id ).first
        else
          User.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :purchaseChannel, Types::PurchaseChannelType do
    argument :id, types.ID
    argument :reference, types.String
    description "Purchase Channels"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'PurchaseChannel'
          PurchaseChannel.where(id: record_id ).first
        else
          PurchaseChannel.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :deliveryService, Types::DeliveryServiceType do
    argument :id, types.ID
    argument :reference, types.String
    description "Delivery Service"

    resolve ->(obj, args, ctx) { 
      begin
        raise "Not connected or no permission to this query." unless ctx[:current_user].present? && ctx[:current_user].role.in?(['stores', 'transportation', 'admin'])
        if args[:id]
          record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(args[:id])
          raise "ID error" unless record_class_name == 'DeliveryService'
          DeliveryService.where(id: record_id ).first
        else
          DeliveryService.where(reference: args[:reference]).first
        end
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
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
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end

  field :reportSummary, types[Types::BatchReportPerMonthType] do
    argument :year, !types.Int
    argument :purchase_channel_agregated, types.Boolean, default_value: true
    description "Financial Report Summary"

    resolve -> (obj, args, ctx) {
      begin
        batchReport = BatchReport.where(status: 'sent').where("extract(year from updated_at) = ?", args[:year]).
          order("extract(month from updated_at)").
          group("extract(month from updated_at)").
          select("extract(month from updated_at) as month, sum(total_value) total_value, sum(orders) orders, 0 purchase_channel_id")

        if args[:purchase_channel_agregated]
          batchReport = batchReport.group("purchase_channel_id, extract(month from updated_at)").
            select("extract(month from updated_at) as month, purchase_channel_id, sum(total_value) total_value, sum(orders) orders")
        end
        batchReport
      rescue Exception => e
        GraphQL::ExecutionError.new(e.to_s)
      end
    }
  end
end
