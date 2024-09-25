require 'rails_helper'

RSpec.describe Api::V1::VotesController, type: :controller do
  describe '#create' do
    before do
      @game = create(:game, started_at: Time.now, round: 1)
      player = create(:player, game: @game)
      prompt = create(:prompt)
      create(:game_prompt, game: @game, prompt: prompt)
      @prompt_response = create(:response, prompt: prompt, game: @game, player: player)
      @player = create(:player)
    end

    it 'should create a vote' do
      expect(@prompt_response.votes.count).to eq(0)

      post :create, params: { response_id: @prompt_response.id, player_id: @player.id, room_code: @game.room_code }

      expect(@prompt_response.votes.count).to eq(1)
    end

    it 'should broadcast a message with a game' do
      vote_params = { response_id: @prompt_response.id, player_id: @player.id, room_code: @game.room_code }
      
      expect {
        post :create, params: vote_params
      }.to have_broadcasted_to(@game.room_code).with(
        type: 'NEW_VOTE',
        game: anything
      )
    end
  end
end
