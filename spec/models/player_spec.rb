# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  host       :boolean          default(FALSE)
#  name       :string           not null
#  score      :integer          default(0)
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

    it 'should return an error if 8 players are already associated with a game' do
      game = create(:game)
      create(:player, game: game, host: true)
      create_list(:player, 7, game: game)

      player = build(:player, game: game)
      player.save

      expect(player.valid?).to be false
      expect(player.persisted?).to be false
      expect(player.errors.full_messages.last).to eq('Sorry, this game is full (8 players)')
    end
  end

  context 'associations' do
    it { should belong_to(:game) }
  end
end
