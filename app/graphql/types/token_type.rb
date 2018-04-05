Types::TokenType = GraphQL::ScalarType.define do
  name 'TokenType'

  # coerce_input ->(value, _ctx) { binding.pry }
  # coerce_result ->(o,c) { 
  # 	binding.pry
  # 	#o.token(c[:current_user])
  # }
end
