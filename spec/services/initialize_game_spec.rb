require 'rails_helper'

RSpec.describe 'InitializeGame', type: :service do
  context 'call' do
    before do
      @game = create(:game)
    end

    it 'should call start on the game' do
      expect(@game).to receive(:start!)

      InitializeGame.call(@game)
    end

    it 'should call assign_prompts on the game' do
      expect(@game).to receive(:assign_prompts!)

      InitializeGame.call(@game)
    end

    it 'should not call start on the game if the game has already started' do
      game = create(:game, started_at: Time.zone.now)

      expect(game).not_to receive(:start!)
      expect(game).not_to receive(:assign_prompts!)

      InitializeGame.call(game)
    end
  end
end
