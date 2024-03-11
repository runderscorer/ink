require 'rails_helper'

RSpec.describe Api::V1::GamesController, type: :controller do
  describe '#create' do
    it 'should create a new game with a room code' do
      post :create, params: { room_code: 'pizza' }

      expect(response.status).to eq(200)
      expect(parse_response['game']['room_code']).to eq('pizza')
    end

    it 'should create a new game with a random room code if one is not provided' do
      post :create

      expect(response.status).to eq(200)
      expect(parse_response['game']['room_code']).not_to be_nil
    end

    it 'should return an error message if the room code is already taken' do
      create(:game, room_code: 'TAKEN')
      
      post :create, params: { room_code: 'TAKEN' }

      expect(response.status).to eq(400)
      expect(parse_response['errors']).to eq(['Room code has already been taken'])
    end
  end
end