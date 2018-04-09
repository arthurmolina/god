require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::ClientsSearch
  include SearchObject.module(:graphql)

  scope { Client.all }

  type !types[Types::ClientType]

  ClientFilter = GraphQL::InputObjectType.define do
    name 'ClientFilter'

    argument :OR, -> { types[ClientFilter] }
    argument :name_contains, types.String
    argument :address_contains, types.String
  end

  SortEnum = GraphQL::EnumType.define do
    name 'ClientSortBy'

    value 'createdAt_ASC'
    value 'createdAt_DESC'
    value 'name_ASC'
    value 'name_DESC'
  end

  option :filter, type: ClientFilter, with: :apply_filter
  option :sortBy, type: SortEnum, default: 'createdAt_DESC'

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = Client.all
    scope = scope.like(:name, value['name_contains']) if value['name_contains']
    scope = scope.like(:address, value['address_contains']) if value['address_contains']

    branches << scope

    value['OR'].reduce(branches) { |s, v| normalize_filters(v, s) } if value['OR'].present?

    branches
  end

  def apply_sortBy_with_created_at_asc(scope)
    scope.order('created_at ASC')
  end

  def apply_sortBy_with_created_at_desc(scope)
    scope.order('created_at DESC')
  end

  def apply_sortBy_with_name_asc(scope)
    scope.order('name ASC')
  end

  def apply_sortBy_with_name_desc(scope)
    scope.order('name DESC')
  end

  def fetch_results
    # NOTE: Don't run QueryResolver during tests
    return super unless context.present?
    raise "Not connected or no permission to this query." unless context[:current_user].present? && context[:current_user].role.in?(['stores', 'transportation', 'admin'])

    GraphQL::QueryResolver.run(Client, context, Types::ClientType) do
      super
    end
  end
end
