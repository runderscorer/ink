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
require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'validations' do
    it 'should validate the presence of a name' do
      game = create(:game, room_code: 'PIZZA')
      player = build(:player, name: nil, game: game)
      player.save

      expect(player.errors.full_messages.last).to eq("Name can't be blank")
    end
  end

  context 'associations' do
    it 'should belong to a game' do
      game = create(:game, room_code: 'PIZZA')
      player = create(:player, game: game)

      expect(player.game).to eq(game)
    end
  end
end
