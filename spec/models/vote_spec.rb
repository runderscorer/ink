
require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'associations' do
    it { should belong_to(:player) }
    it { should belong_to(:response) }
  end
end
