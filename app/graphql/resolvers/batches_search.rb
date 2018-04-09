require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::BatchesSearch
  include SearchObject.module(:graphql)

  scope { Batch.all }

  type !types[Types::BatchType]

  BatchFilter = GraphQL::InputObjectType.define do
    name 'BatchFilter'

    argument :OR, -> { types[BatchFilter] }
    argument :reference_contains, types.String
    argument :status, types.String
  end

  SortEnum = GraphQL::EnumType.define do
    name 'BatchSortBy'

    value 'createdAt_ASC'
    value 'createdAt_DESC'
  end

  option :filter, type: BatchFilter, with: :apply_filter
  option :sortBy, type: SortEnum, default: 'createdAt_DESC'

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    binding.pry
    scope = Batch.all
    scope = scope.like(:reference, value['reference_contains']) if value['reference_contains']
    scope = scope.like(:status, value['status']) if value['status']

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

    raise "Not connected or no permission." unless context[:current_user].present? && context[:current_user].role > 1

    GraphQL::QueryResolver.run(Batch, context, Types::BatchType) do
      super
    end

  rescue Exception => e
    GraphQL::ExecutionError.new("Error: #{e.to_s}")
  end
end
