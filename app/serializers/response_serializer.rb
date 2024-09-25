class ResponseSerializer
  include JSONAPI::Serializer

  attributes :text, :prompt_id, :game_id, :correct, :player_id, :votes

  belongs_to :player
  has_many :votes
end
