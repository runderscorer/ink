# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  host       :boolean          default(FALSE)
#  name       :string           not null
#  score      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#
class PlayerSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :game_id
end
