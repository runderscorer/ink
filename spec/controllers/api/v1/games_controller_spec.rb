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

    describe 'with host name' do
      it 'should create a new game with a host' do
        post :create, params: { room_code: 'SHOWTIME', host_name: 'Beetlejuice' }

        expect(response.status).to eq(200)
      
        expect(parse_response_attributes['host']['name']).to eq('Beetlejuice')
      end
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
      expect(parse_response_attributes['player_names'].count).to eq(3)
    end

    it 'should find the game by room code regardless of case' do
      game = create(:game, room_code: 'FOUND')

      get :search, params: { room_code: 'found' }

      expect(response.status).to eq(200)

      expect(parse_response_attributes['room_code']).to eq('FOUND')
    end
  end

  describe '#start' do
    before do
      @game = create(:game)
      create_list(:player, 3, game: @game)
      create_list(:prompt, 3)
    end

    it 'should broadcast a message with a game' do
      expect {
        patch :start, params: { room_code: @game.room_code }
      }.to have_broadcasted_to(@game.room_code).with(
        type: 'GAME_STARTED',
        game: anything
      )

      expect(response.status).to eq(200)
      expect(@game.reload.started_at).to be_present
    end

    it 'should return an error message if an error occurs' do
      allow_any_instance_of(Game).to receive(:assign_prompts!).and_raise(StandardError.new('An error occurred'))

      patch :start, params: { room_code: @game.room_code }

      expect(response.status).to eq(400)
      expect(parse_response['error_message']).to eq('An error occurred')
    end
  end

  describe '#next_round' do
    it 'should call the AdvanceRound service' do
      game = create(:game)
      player = create(:player, game: game)

      expect(AdvanceRound).to receive(:call).with(game: game, player: player).and_call_original

      patch :next_round, params: { room_code: game.room_code, player_id: player.id }
    end

    it 'should return an error message if an error occurs' do
      game = create(:game, :with_prompts)

      patch :next_round, params: { room_code: game.room_code, player_id: nil }

      expect(parse_response['error_message']).to eq('Host not found')
    end
  end
end