require 'rails_helper'

RSpec.describe Api::V1::ResponsesController, type: :controller do
  describe '#create' do
    before do
      @game = create(:game, :with_prompts, room_code: 'PIZZA')
      @player = create(:player, game: @game)
    end

    it 'should create a response' do
      expect(@game.current_prompt.responses.count).to eq(1)

      post :create, params: { text: 'more pineapple please', player_id: @player.id, room_code: @game.room_code }

      expect(@game.current_prompt.responses.count).to eq(2)
      expect(@game.current_prompt.responses.pluck(:text)).to include('more pineapple please')
    end

    it 'should update the game status to gathering_votes if all responses are submitted' do
      game = create(:game, :with_prompts)
      players = create_list(:player, 3, game: game)

      expect(game.status).to eq('gathering_responses')

      players.each do |player|
        post :create, params: { 
          text: Faker::Fantasy::Tolkien.poem, 
          player_id: player.id, 
          room_code: game.room_code 
        }
      end

      expect(game.reload.status).to eq('gathering_votes')
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

  describe '#generate_text' do
    it 'should return a response from the GeminiApi service' do
      game = create(:game, :with_prompts)

      expect_any_instance_of(GeminiApi).to receive(:generate_response).and_return('Stubbed Gemini response')  

      get :generate_text, params: { room_code: game.room_code }

      expect(response.body).to eq({ text: 'Stubbed Gemini response' }.to_json)
    end

    it 'should return an error message if there is no current prompt' do
      game = create(:game)

      get :generate_text, params: { room_code: game.room_code }

      expect(response.body).to eq({ error_message: 'There was an error generating a response' }.to_json)
    end
  end
end
