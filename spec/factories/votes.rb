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
FactoryBot.define do
  factory :vote do
    response
    player
  end
end
