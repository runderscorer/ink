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

    it 'should call get_prompts on the game' do
      expect(@game).to receive(:get_prompts!)

      InitializeGame.call(@game)
    end
  end
end
