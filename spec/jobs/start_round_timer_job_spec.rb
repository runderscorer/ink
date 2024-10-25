require 'rails_helper'

RSpec.describe StartRoundTimerJob, type: :job do
  describe '#perform' do
    it 'should set the round timer for the game' do
      allow_any_instance_of(StartRoundTimerJob).to receive(:sleep)
      game = create(:game)

      expect {
        StartRoundTimerJob.perform_now(game.room_code, game.round)
      }.to have_broadcasted_to(game.room_code).with(
        type: 'ROUND_TIMER',
        round: game.round,
        elapsed_time: anything
      ).exactly(100).times
    end
  end
end
