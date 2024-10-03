# == Schema Information
#
# Table name: votes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :integer
#  player_id   :bigint
#  response_id :integer
#
# Indexes
#
#  index_votes_on_player_id  (player_id)
#
class VoteSerializer
  include JSONAPI::Serializer

  attributes :id, :player_id, :response_id, :player_name, :game_id

  belongs_to :player
  belongs_to :response

  attribute :player_name do |object|
    object.player.name
  end
end
