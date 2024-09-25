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
class Vote < ApplicationRecord
  belongs_to :player
  belongs_to :response

  scope :by_game, ->(room_code) { where(player_id: Player.by_game(room_code).pluck(:id)) }
end
