class GameSerializer
  include JSONAPI::Serializer

  attributes :room_code, :player_count

  attribute :player_count do |object|
    object.players.count
  end
end
