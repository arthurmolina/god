Types::BatchReportType = GraphQL::ObjectType.define do
  name "BatchReport"
  #interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id
 
  field :reference, types.String
  field :status, types.String
  field :purchase_channel, Types::PurchaseChannelType
  field :total_value, types.Float
  field :orders, types.Int

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, args, ctx) { obj.errors.full_messages }
  end
end
