require 'rails_helper'

RSpec.describe Api::V1::ReactionsController, type: :controller do
  describe '#create' do
    before do
      @player = create(:player)
      @player_response = create(:response, player: @player)
    end

    it 'should create a reaction' do
      expect(Reaction.count).to eq(0)

      post :create, params: { 
        reaction: {
          kind: 'like', response_id: @player_response.id, player_id: @player.id 
        }
      }

      reaction = Reaction.last

      expect(Reaction.count).to eq(1)
      expect(reaction.kind).to eq('like')
      expect(reaction.response).to eq(@player_response)
      expect(reaction.player).to eq(@player)
    end
  end
end
