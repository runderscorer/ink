# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
require 'rails_helper'

RSpec.describe GameSerializer do
  before do
    game = create(:game)
    create_list(:prompt, 9)
    create_list(:player, 3, game: game)
    InitializeGame.call(game: game)

    @game = GameSerializer.new(game).serializable_hash
  end

  context 'attributes' do
    describe 'current_prompt' do
      it 'should return nil if there is no current prompt' do
        game = create(:game)
        game = GameSerializer.new(game).serializable_hash

        expect(game[:data][:attributes][:current_prompt]).to be_nil
      end

      it 'should return the current prompt' do
        expect(@game[:data][:attributes][:current_prompt][:id]).to be_present
        expect(@game[:data][:attributes][:current_prompt][:text]).to be_present
        expect(@game[:data][:attributes][:current_prompt][:author]).to be_present
      end
    end

    describe 'status' do
      it 'should return the status name' do
        game = create(:game)
        game = GameSerializer.new(game).serializable_hash

        expect(game[:data][:attributes][:status]).to eq('waiting')

        game = create(:game, :gathering_responses)
        game = GameSerializer.new(game).serializable_hash

        expect(game[:data][:attributes][:status]).to eq('gathering_responses')

        game = create(:game, :gathering_votes)
        game = GameSerializer.new(game).serializable_hash

        expect(game[:data][:attributes][:status]).to eq('gathering_votes')
      end
    end
  end
end
