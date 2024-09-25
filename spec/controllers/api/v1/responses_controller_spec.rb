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
    end

    it 'should broadcast a message with a game' do
      response_params = { text: 'more pineapple please', player_id: @player.id, room_code: @game.room_code }

      expect {
        post :create, params: response_params
      }.to have_broadcasted_to(@game.room_code).with(
        type: 'NEW_RESPONSE',
        game: anything
      )
    end
  end
end
