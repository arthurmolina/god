GraphQL::Field.accepts_definitions is_public: GraphQL::Define.assign_metadata_key(:is_public)
GraphQL::Field.accepts_definitions must_be: GraphQL::Define.assign_metadata_key(:must_be)


GodSchema = GraphQL::Schema.define do
  mutation(Types::MutationType)
  query(Types::QueryType)

  resolve_type ->(type, obj, ctx) {
    case obj
    when Order
      Types::OrderType
    when Batch
      Types::BatchType
    when Client
      Types::ClientType
    when PurchaseChannel
      Types::PurchaseChannelType
    when DeliveryService
      Types::DeliveryServiceType
    when User
      Types::UserType
    else
      raise("Unexpected object: #{obj}")
    end
  }

  id_from_object lambda { |object, _definition, _ctx|
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  }

  object_from_id lambda { |id, _ctx|
    return unless id.present?
    record_class_name, record_id = GraphQL::Schema::UniqueWithinType.decode(id)
    record_class = record_class_name.safe_constantize
    record_class&.find_by id: record_id
  }
end


