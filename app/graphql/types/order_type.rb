Types::OrderType = GraphQL::ObjectType.define do
  name "Order"
  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id
 
  field :reference, types.ID
  field :total_value, types.Float
  field :line_items, types.String, "Line items"
  field :status, types.String, "Status of the order"
  field :created_at, Types::DateTimeType

  field :purchase_channel, -> {Types::PurchaseChannelType}
  field :client,           -> {Types::ClientType}
  field :delivery_service, -> {Types::DeliveryServiceType}
  field :batch,            -> {Types::BatchType}

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, args, ctx) { obj.errors.full_messages }
  end
end
