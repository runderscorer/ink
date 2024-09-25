# == Schema Information
#
# Table name: votes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#  response_id :integer
#
# Indexes
#
#  index_votes_on_player_id  (player_id)
#
class VoteSerializer
  include JSONAPI::Serializer

  attributes :id, :player_id, :response_id

  belongs_to :player
  belongs_to :response
end
