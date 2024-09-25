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
      
      vote = parse_response['vote']['data']['attributes']
      game = parse_response['game']['data']['attributes']
      current_prompt = game['current_prompt']
      response = current_prompt['responses']['data'][0]['attributes']

      expect(vote['player_id']).to eq(@player.id)
      expect(vote['response_id']).to eq(@prompt_response.id)
      expect(response['votes'].pluck('id')).to include(vote['id'])
    end
  end
end
