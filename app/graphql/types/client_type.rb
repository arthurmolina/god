Types::ClientType = GraphQL::ObjectType.define do
  name "Client"
  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id

  field :name, types.String
  field :address, types.String
  field :orders, -> {types[Types::OrderType]}

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, args, ctx) { obj.errors.full_messages }
  end
end
