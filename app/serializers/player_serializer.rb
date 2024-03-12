class PlayerSerializer
  include JSONAPI::Serializer

  attributes :name, :game_id
end
