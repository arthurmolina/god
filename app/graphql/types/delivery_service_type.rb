Types::DeliveryServiceType = GraphQL::ObjectType.define do
  name "DeliveryService"
  interfaces [GraphQL::Relay::Node.interface]
  global_id_field :id
 
  field :name, types.String

  field :errors, types[types.String], "Reasons the object couldn't be created or updated" do
    resolve ->(obj, args, ctx) { obj.errors.full_messages }
  end
end
