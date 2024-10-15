require 'rails_helper'

RSpec.describe Response, type: :model do
  context 'associations' do
    it { should belong_to(:prompt) }
    it { should have_many(:votes) }
    it { should have_many(:reactions) }
  end

  context 'scopes' do
    describe 'not_archived' do
      it 'should not return responses that are archived' do
        archived = create(:response, :archived)
        not_archived = create(:response)

        responses = Response.not_archived
        expect(responses).to_not include(archived)
        expect(responses).to include(not_archived)
      end
    end

    describe 'by_game' do
      it 'should return responses by game' do
        game = create(:game, room_code: 'RM237')
        other_game = create(:game, room_code: 'RM238')
        prompt = create(:prompt)
        create(:game_prompt, game: game, prompt: prompt)

        response = create(:response, game: game, prompt: prompt)
        other_response = create(:response, game: other_game, prompt: prompt)

        responses = Response.by_game('RM237')

        expect(responses).to include(response)
        expect(responses).to_not include(other_response)
      end
    end
  end
end