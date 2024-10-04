require 'rails_helper'

RSpec.describe Response, type: :model do
  context 'associations' do
    it { should belong_to(:prompt) }
    it { should have_many(:votes) }
    it { should have_many(:reactions) }
  end
end