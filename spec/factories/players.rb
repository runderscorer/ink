# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  host       :boolean          default(FALSE)
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#
FactoryBot.define do
  factory :player do
    name { 'Mario' }
    game
  end
end
