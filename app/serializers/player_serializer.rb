class PlayerSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :game_id
end
