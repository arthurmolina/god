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
    request_auth = request.headers
    if params['variables'].present? && params['variables']['Authorization'].present?
      request_auth = params['variables']
    end

    @current_user = AuthorizeApiRequest.call(request_auth).result
  end 

end
