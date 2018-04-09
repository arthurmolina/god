require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::OrdersSearch
  include SearchObject.module(:graphql)

  scope { context[:current_user].role == 'stores' ? Order.where(purchase_channel_id: context[:current_user].purchase_channel_id) : Order.all }

  type !types[Types::OrderType]

  OrderFilter = GraphQL::InputObjectType.define do
    name 'OrderFilter'

    argument :OR, -> { types[OrderFilter] }
    argument :reference_contains, types.String
    argument :total_value_contains, types.String
    argument :line_items_contains, types.String
    argument :purchase_channel_id, types[types.Int]
    argument :delivery_service_id, types[types.Int]
    argument :only_not_associated_to_batch, types.Boolean
    argument :only_associated_to_batch, types.Boolean
  end

  SortEnum = GraphQL::EnumType.define do
    name 'OrderSortBy'

    value 'createdAt_ASC'
    value 'createdAt_DESC'
  end

  option :filter, type: OrderFilter, with: :apply_filter
  option :sortBy, type: SortEnum, default: 'createdAt_DESC'

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = context[:current_user].role == 'stores' ? Order.where(purchase_channel_id: context[:current_user].purchase_channel_id) : Order.all
    scope = scope.like(:reference, value['reference_contains']) if value['reference_contains']
    scope = scope.like(:total_value, value['total_value_contains']) if value['total_value_contains']
    scope = scope.like(:line_items, value['line_items_contains']) if value['line_items_contains']
    scope = scope.like(:total_value, value['total_value_contains']) if value['total_value_contains']
    scope = scope.where(purchase_channel_id: value['purchase_channel_id']) if value['purchase_channel_id']
    scope = scope.where(delivery_service_id: value['delivery_service_id']) if value['delivery_service_id']
    scope = scope.where(batch_id: nil) if value['only_not_associated_to_batch'] && value['only_not_associated_to_batch'] == true
    scope = scope.where.not(batch_id: nil) if value['only_associated_to_batch'] && value['only_associated_to_batch'] == true

    branches << scope

    value['OR'].reduce(branches) { |s, v| normalize_filters(v, s) } if value['OR'].present?

    branches
  end

  def apply_sortBy_with_created_at_asc(scope) # rubocop:disable Style/MethodName
    scope.order('created_at ASC')
  end

  def apply_sortBy_with_created_at_desc(scope) # rubocop:disable Style/MethodName
    scope.order('created_at DESC')
  end

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?
    raise "Not connected or no permission to this query." unless context[:current_user].present? && context[:current_user].role.in?(['stores', 'production', 'transportation', 'admin'])

    GraphQL::QueryResolver.run(Order, context, Types::OrderType) do
      super
    end
  end
end
