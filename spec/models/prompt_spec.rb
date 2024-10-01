# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  author     :string
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Prompt, type: :model do
  context 'associations' do
    describe 'votes' do
      before do
        @prompt = create(:prompt)
        response = create(:response, prompt: @prompt)
        @vote = create(:vote, response: response)
      end

      it 'should have many votes' do
        expect(@prompt.votes).to include(@vote)
      end
    end
  end
end
