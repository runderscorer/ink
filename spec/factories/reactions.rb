# == Schema Information
#
# Table name: reactions
#
#  id          :bigint           not null, primary key
#  kind        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#  response_id :bigint
#
# Indexes
#
#  index_reactions_on_player_id    (player_id)
#  index_reactions_on_response_id  (response_id)
#
FactoryBot.define do
  factory :reaction do
  end
end
