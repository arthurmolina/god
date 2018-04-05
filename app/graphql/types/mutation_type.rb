Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :login, function: Mutations::Login.new
  field :sign_up, function: Mutations::SignUp.new

end