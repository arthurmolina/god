Types::PurchaseChannelType = GraphQL::ObjectType.define do
 name "PurchaseChannelType"

 field :id, types.ID
 field :name, types.String
end
