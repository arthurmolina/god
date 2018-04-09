class GraphqlController < ApplicationController
  before_action :check_authentication

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
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
    if !parsed_query.selected_operation.nil?
      operation = parsed_query.selected_operation.selections.first.name
      operations = parsed_query.selected_operation.selections.map(&:name)
      return true if operation.in? ['__schema', 'login', 'sign_up', 'allOrders', 'auth']
    end

    queries_list = GodSchema.query.fields.keys
    mutations_list = GodSchema.mutation.fields.keys

    request_auth = request.headers
    if params['variables']['Authorization'].present?
      request_auth = params['variables']
    end

    #return true

    #binding.pry
    #field = GodSchema.query.fields[operation] || GodSchema.mutation.fields[operation]
    #return true if field.metadata[:is_public]
    
    @current_user = AuthorizeApiRequest.call(request_auth).result
    
    #binding.pry
    #unless @current_user = AuthorizeApiRequest.call(request_auth).result
    #  GraphQL::ExecutionError.new("Error: Not authorized.")
    #  render json: {message: "Not authorized.", response: 401}
    #  #head(:unauthorized)
    #  return false
    #end

    #binding.pry

    #unless field.metadata[:must_be].to_a.include? @current_user.role
    # =>   GraphQL::ExecutionError.new("Error: Not authorized.")
    #  render json: {message: "Not authorized.", response: 401}
    #  #head(:unauthorized)
    #  return false
    #end
  end 

end
