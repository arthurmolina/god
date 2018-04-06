require 'search_object/plugin/graphql'
require 'graphql/query_resolver'

class Resolvers::UsersSearch
  include SearchObject.module(:graphql)

  scope { User.all }

  type !types[Types::UserType]

  UserFilter = GraphQL::InputObjectType.define do
    name 'UserFilter'

    argument :OR, -> { types[UserFilter] }
    argument :name_contains, types.String
    argument :email_contains, types.String
  end

  SortEnum = GraphQL::EnumType.define do
    name 'UserSortBy'

    value 'createdAt_ASC'
    value 'createdAt_DESC'
    value 'name_ASC'
    value 'name_DESC'
  end

  option :filter, type: UserFilter, with: :apply_filter
  option :sortBy, type: SortEnum, default: 'createdAt_DESC'

  def apply_filter(scope, value)
    branches = normalize_filters(value).reduce { |a, b| a.or(b) }
    scope.merge branches
  end

  def normalize_filters(value, branches = [])
    scope = User.all
    scope = scope.like(:name, value['name_contains']) if value['name_contains']
    scope = scope.like(:email, value['email_contains']) if value['email_contains']

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

    GraphQL::QueryResolver.run(User, context, Types::UserType) do
      super
    end
  end
end
