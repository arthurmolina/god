Types::MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  # Authentication
  field :login, function: Mutations::Login.new
  field :sign_up, function: Mutations::SignUp.new

  # Order management
  field :createOrder, function: Mutations::CreateOrder.new
  field :updateOrder, function: Mutations::UpdateOrder.new

  # Batch management
  field :createBatch,  function: Mutations::CreateBatch.new
  field :produceBatch, function: Mutations::ProduceBatch.new
  field :closeBatch, function: Mutations::CloseBatch.new
  
end