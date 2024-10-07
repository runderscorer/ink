require 'rails_helper'

RSpec.describe 'CreateGame', type: :service do
  describe 'call' do
    context 'with errors' do
      it 'should return an error if the game has errors' do
        results = CreateGame.call(room_code: 'TOOTOOTOOLONG', host_name: 'HOST')

        expect(results.success?).to be false
        expect(results.error_message).to eq("Room code is too long (maximum is 10 characters)")
      end

      it 'should return an error if the player has errors' do
        results = CreateGame.call(room_code: 'PERFECT', host_name: 'TOOTOOTOOLONG')

        expect(results.success?).to be false
        expect(results.error_message).to eq("Name is too long (maximum is 10 characters)")
        
        game = Game.find_by(room_code: 'PERFECT')

        expect(game).to be_nil
      end
    end
  end
end
