require 'rails_helper'

RSpec.describe Api::V1::PlayersController, type: :controller do
  describe '#create' do
    it 'should create a new player' do
      game = create(:game, room_code: 'PIZZA')
      post :create, params: { name: 'Luigi', room_code: game.room_code }

      expect(response.status).to eq(200)
      expect(parse_response_attributes['name']).to eq('Luigi')
    end

    it 'should return an error message if the player is not valid' do
      game = create(:game, room_code: 'PIZZA')
      post :create, params: { name: nil, room_code: game.room_code }

      expect(response.status).to eq(400)
      expect(parse_response['errors']).to eq(["Name can't be blank"])
    end

    it 'should return an error message if the game is not found' do
      post :create, params: { name: 'Luigi', room_code: 'WHEREAMI' }

      expect(response.status).to eq(404)
      expect(parse_response['errors']).to eq('Game not found. Please try another room code.')
    end
  end
end
