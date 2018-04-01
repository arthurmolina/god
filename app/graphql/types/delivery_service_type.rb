Types::DeliveryServiceType = GraphQL::ObjectType.define do
 name "DeliveryServiceType"

 field :id, types.ID
 field :name, types.String
end
