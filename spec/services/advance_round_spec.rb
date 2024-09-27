require 'rails_helper'

RSpec.describe 'AdvanceRound', type: :service do
  describe 'call' do
    it 'should return an error if the game is not found' do
      result = AdvanceRound.call(game: nil)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Game not found')
    end

    it 'should return an error if the game has not started' do
      game = create(:game, started_at: nil)
      result = AdvanceRound.call(game: game)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Game not started')
    end

    it 'should return an error a game host is not found' do
      game = create(:game, :with_prompts)
      result = AdvanceRound.call(game: game, player: nil)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Host not found')

      game = create(:game, :with_prompts)
      player = create(:player, game: create(:game))
      result = AdvanceRound.call(game: game, player: player)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Host not found')
    end

    it 'should return an error if the player is not the host' do
      game = create(:game, :with_prompts)
      create(:player, game: game, host: true)
      player = create(:player, game: game)
      result = AdvanceRound.call(game: game, player: player)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Only the host can start the next round')
    end

    it 'should increment the round and update the status' do
      game = create(:game, :with_prompts, :viewing_scores)
      host = create(:player, game: game, host: true)
      result = AdvanceRound.call(game: game, player: host)

      expect(result.success?).to be true
      expect(game.reload.round).to eq(2)
      expect(game.reload.status).to eq('gathering_responses')
    end

    it 'should broadcast a message with the game' do
      game = create(:game, :with_prompts, :viewing_scores)
      host = create(:player, game: game, host: true)

      expect {
        AdvanceRound.call(game: game, player: host)
      }.to have_broadcasted_to(game.room_code).with(
        type: 'NEXT_ROUND',
        game: anything
      )
    end
  end
end
