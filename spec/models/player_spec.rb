require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'validations' do
    it 'should validate the presence of a name' do
      player = build(:player, name: nil)
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
