class GraphqlController < ApplicationController
  before_action :check_authentication

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      current_user: @current_user,
    }
    result = GodSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def check_authentication
    parsed_query = GraphQL::Query.new GodSchema, params[:query]
    operation = parsed_query.selected_operation.selections.first.name
    return true if operation.in? ['__schema', 'login', 'sign_up']

    field = GodSchema.query.fields[operation] || GodSchema.mutation.fields[operation]
    return true if field.metadata[:is_public]

    unless @current_user = AuthorizeApiRequest.call(request.headers).result
      GraphQL::ExecutionError.new("Error: Not authorized.")
      render json: {message: "Not authorized.", response: 401}
      #head(:unauthorized)
      return false
    end

    unless field.metadata[:must_be].to_a.include? @current_user.role
      GraphQL::ExecutionError.new("Error: Not authorized.")
      render json: {message: "Not authorized.", response: 401}
      #head(:unauthorized)
      return false
    end
  end    
end
