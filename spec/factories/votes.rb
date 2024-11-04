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
FactoryBot.define do
  factory :vote do
    response
    player
    game
  end
end
