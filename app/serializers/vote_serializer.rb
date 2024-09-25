class VoteSerializer
  include JSONAPI::Serializer

  attributes :id, :player_id, :response_id

  belongs_to :player
  belongs_to :response
end
