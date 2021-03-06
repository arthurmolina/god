Types::BatchType = GraphQL::ObjectType.define do
  name "Batch"
  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id
 
  field :reference, types.String
  field :status, types.String
  field :purchase_channel, Types::PurchaseChannelType
  field :purchase_channel_id, types.Int
  connection :orders, Types::OrderType.connection_type

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, args, ctx) { obj.errors.full_messages }
  end
end
