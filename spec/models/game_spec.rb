require 'rails_helper'

RSpec.describe 'Game', type: :model do
  context 'validations' do
    it 'should validate the uniqueness of a room_code' do
      create(:game, room_code: 'TAKEN')
      game = build(:game, room_code: 'TAKEN')
      game.save

      expect(game.errors.full_messages.last).to eq('Room code has already been taken')
    end

    it 'should validate the presence of a room_code' do
      game = build(:game, room_code: nil)
      game.save

      expect(game.errors.full_messages.last).to eq("Room code can't be blank")
    end
  end
end