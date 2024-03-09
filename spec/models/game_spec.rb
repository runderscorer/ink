require 'rails_helper'

RSpec.describe 'Game', type: :model do
  context 'validations' do
    it 'should validate the uniqueness of the room_code' do
      create(:game, room_code: 'TAKEN')

      game = build(:game, room_code: 'TAKEN')
    end
  end
end