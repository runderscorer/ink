class ReactionSerializer
  include JSONAPI::Serializer

  attributes :player_id, :response_id, :kind
end
