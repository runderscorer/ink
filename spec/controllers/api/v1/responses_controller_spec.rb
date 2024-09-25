require 'rails_helper'

RSpec.describe Api::V1::ResponsesController, type: :controller do
  describe '#create' do
    before do
      @game = create(:game, :with_prompts, room_code: 'PIZZA')
      @player = create(:player, game: @game)
    end

    it 'should create a prompt' do
      expect(@game.current_prompt.responses.count).to eq(1)

      post :create, params: { text: 'more pineapple please', player_id: @player.id, room_code: @game.room_code }

      expect(@game.current_prompt.responses.count).to eq(2)
      expect(@game.current_prompt.responses.pluck(:text)).to include('more pineapple please')
      
      response = parse_response['response']['data']['attributes']

      expect(response['player_id']).to eq(@player.id)
      expect(response['correct']).to eq(false)
      expect(response['text']).to eq('more pineapple please')
      expect(response['prompt_id']).to eq(@game.current_prompt.id)
      expect(response['game_id']).to eq(@game.id)
    end
  end
end
