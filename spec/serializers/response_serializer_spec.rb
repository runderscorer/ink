require 'rails_helper'

RSpec.describe ResponseSerializer do
  context 'attributes' do
    describe 'votes' do
      it 'should only return the votes from current game' do
        prompt = create(:prompt)
        correct_response = create(:response, prompt: prompt, game: nil, correct: true)

        game = create(:game, room_code: 'VOTEY', started_at: Time.now, round: 1)
        game_prompt = create(:game_prompt, game: game, prompt: prompt)
        player = create(:player, game: game)
        vote = create(:vote, response: correct_response, game: game, player: player)

        other_game = create(:game, room_code: 'NOTVOTEY', started_at: Time.now, round: 1)
        other_player = create(:player, game: other_game)
        other_game_prompt = create(:game_prompt, game: other_game, prompt: prompt)
        other_vote = create(:vote, response: correct_response, game: other_game, player: other_player)

        response = ResponseSerializer.new(correct_response, params: { game_id: game.id }).serializable_hash

        votes = response[:data][:attributes][:votes][:data]
        expect(votes.count).to eq(1)
        expect(votes.first[:id]).to eq(vote.id.to_s)

        response = ResponseSerializer.new(correct_response, params: { game_id: other_game.id }).serializable_hash

        votes = response[:data][:attributes][:votes][:data]
        expect(votes.count).to eq(1)
        expect(votes.first[:id]).to eq(other_vote.id.to_s)
      end
    end
  end
end
