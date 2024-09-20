# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
require 'rails_helper'

RSpec.describe 'Game', type: :model do
  context 'validations' do
    it 'should validate the uniqueness of a room_code' do
      create(:game, room_code: 'TAKEN')
      game = build(:game, room_code: 'taken')
      game.save

      expect(game.errors.full_messages.last).to eq('Room code has already been taken')
    end

    it 'should validate the presence of a room_code' do
      game = build(:game, room_code: nil)
      game.save

      expect(game.errors.full_messages.last).to eq("Room code can't be blank")
    end
  end

  it 'should normalize the room_code before saving' do
    game = create(:game, room_code: 'pizza')

    expect(game.room_code).to eq('PIZZA')
  end
end
