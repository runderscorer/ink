require 'rails_helper'

RSpec.describe 'InitializeGame', type: :service do
  context 'call' do
    before do
      @game = create(:game)
    end

    it 'should call start on the game' do
      expect(@game).to receive(:start!)

      InitializeGame.call(game: @game)
    end

    it 'should call assign_prompts on the game' do
      expect(@game).to receive(:assign_prompts!)

      InitializeGame.call(game: @game)
    end

    it 'should not call start on the game if the game has already started and return an error message' do
      game = create(:game, started_at: Time.zone.now)

      expect(game).not_to receive(:start!)
      expect(game).not_to receive(:assign_prompts!)

      result = InitializeGame.call(game: game)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Game already started')
    end

    it 'should return an error message if an error occurs' do
      game = create(:game)

      allow(game).to receive(:assign_prompts!).and_raise(StandardError.new('An error occurred'))

      result = InitializeGame.call(game: game)

      expect(result.success?).to be false 
      expect(result.error_message).to eq('An error occurred')
    end
  end
end
