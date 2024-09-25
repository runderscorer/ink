# == Schema Information
#
# Table name: votes
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#  response_id :integer
#
# Indexes
#
#  index_votes_on_player_id  (player_id)
#
require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'associations' do
    it { should belong_to(:player) }
    it { should belong_to(:response) }
  end

  context 'scopes' do
    describe 'by_game' do
      before do
        @game = create(:game)
        player = create(:player, game: @game)
        prompt = create(:prompt)
        response = create(:response, prompt: prompt)
        @vote = create(:vote, response: response, player: player)
      end

      it 'should return votes by game' do
        expect(Vote.by_game(@game.room_code)).to include(@vote)
      end
    end
  end
end
