require 'rails_helper'

RSpec.describe Api::V1::GamesController, type: :controller do
  describe '#create' do
    it 'should create a new game with a room code' do
      post :create, params: { room_code: 'pizza' }

      expect(response.status).to eq(200)

      expect(parse_response_attributes['room_code']).to eq('PIZZA')
    end

    it 'should create a new game with a random room code if one is not provided' do
      post :create

      expect(response.status).to eq(200)

      expect(parse_response_attributes['room_code']).not_to be_nil
    end

    it 'should return an error message if the room code is already taken' do
      create(:game, room_code: 'TAKEN')
      
      post :create, params: { room_code: 'TAKEN' }

      expect(response.status).to eq(400)
      expect(parse_response['errors']).to eq(['Room code has already been taken'])
    end
  end

  describe '#search' do
    it 'should return an error if the room code is not provided' do
      get :search

      expect(response.status).to eq(200)
      expect(parse_response['errors']).to eq('Enter a room code.')
    end

    it 'should return an error if a game cannot be found by room code' do
      get :search, params: { room_code: 'NOTFOUND' }

      expect(response.status).to eq(404)
      expect(parse_response['errors']).to eq('Game not found. Please try another room code.')
    end

    it 'should return a game if one is found by room code' do
      game = create(:game, room_code: 'FOUND')
      create_list(:player, 3, game: game)

      get :search, params: { room_code: 'FOUND' }

      expect(response.status).to eq(200)

      expect(parse_response_attributes['room_code']).to eq('FOUND')
      expect(parse_response_attributes['player_count']).to eq(3)
    end

    it 'should find the game by room code regardless of case' do
      game = create(:game, room_code: 'FOUND')

      get :search, params: { room_code: 'found' }

      expect(response.status).to eq(200)

      expect(parse_response_attributes['room_code']).to eq('FOUND')
    end
  end
end