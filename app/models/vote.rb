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
class Vote < ApplicationRecord
  belongs_to :player
  belongs_to :response
  belongs_to :game

  scope :by_game, ->(room_code) { where(game_id: Game.find_by(room_code: room_code)) }
end
