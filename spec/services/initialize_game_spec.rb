require 'rails_helper'

RSpec.describe 'InitializeGame', type: :service do
  describe 'call' do
    context 'with errors' do
      it 'should return an error message if the game is not found' do
        result = InitializeGame.call(game: nil)

        expect(result.success?).to be false
        expect(result.error_message).to eq('Game not found')
      end

      it 'should not call start on the game if the game has already started and return an error message' do
        game = create(:game, started_at: Time.zone.now)

        expect(game).not_to receive(:start!)
        expect(game).not_to receive(:assign_prompts!)

        result = InitializeGame.call(game: game)

        expect(result.success?).to be false
        expect(result.error_message).to eq('Game already started')
      end

      it 'should return an error message if the game has fewer than 2 players' do
        game = create(:game)
        create(:player, game: game, host: true)
        result = InitializeGame.call(game: game)

        expect(result.success?).to be false
        expect(result.error_message).to eq('Game requires at least 2 poets')
      end

      it 'should return an error message if a server error occurs' do
        game = create(:game)
        create(:player, game: game, host: true)
        create(:player, game: game)

        allow(game).to receive(:assign_prompts!).and_raise(StandardError.new('An error occurred'))

        result = InitializeGame.call(game: game)

        expect(result.success?).to be false 
        expect(result.error_message).to eq('An error occurred')
      end
    end

    context 'without errors' do
      before do
        @game = create(:game)
        create(:player, game: @game, host: true)
        create(:player, game: @game)
      end

      it 'should call start on the game' do
        expect(@game).to receive(:start!)

        InitializeGame.call(game: @game)
      end

      it 'should call assign_prompts on the game' do
        expect(@game).to receive(:assign_prompts!)

        InitializeGame.call(game: @game)
      end
    end
  end
end
