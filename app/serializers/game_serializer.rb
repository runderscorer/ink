class GameSerializer
  include JSONAPI::Serializer

  attributes :room_code

  attribute :player_names do |object|
    object.players.pluck(:name)
  end

  attribute :host do |object|
    object.host
  end
end
