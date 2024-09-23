# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
require 'rails_helper'

RSpec.describe 'Game', type: :model do
  describe 'validations' do
    it 'should validate the uniqueness of a room_code' do
      create(:game, room_code: 'TAKEN')
      game = build(:game, room_code: 'taken')
      game.save

      expect(game.errors.full_messages.last).to eq('Room code has already been taken')
    end

    it 'should validate the presence of a room_code' do
      game = build(:game, room_code: nil)
      game.save

      expect(game.errors.full_messages.last).to eq("Room code can't be blank")
    end
  end

  it 'should normalize the room_code before saving' do
    game = create(:game, room_code: 'pizza')

    expect(game.room_code).to eq('PIZZA')
  end

  describe '#start!' do
    it 'should set the started_at date and the round' do
      game = create(:game, started_at: nil, round: nil)

      game.start!

      expect(game.started_at).to be_present
      expect(game.round).to eq(1)
    end
  end

  describe '#assign_prompts!' do
    before do
      create_list(:prompt, 9)
    end

    it 'should assign 3 random prompts to the game' do
      game = create(:game, room_code: 'ROOMY')

      expect(game.prompts.count).to eq(0)

      game.assign_prompts!

      expect(game.prompts.count).to eq(3)
    end
  end

  describe '#current_prompt' do
    it 'should return nil if there are no prompts' do
      game = create(:game, room_code: 'NOPROMPTS')

      expect(game.current_prompt).to be_nil
    end

    it 'should return nil if round is set to nil' do
      game = create(:game, room_code: 'NOROUND')

      expect(game.current_prompt).to be_nil
    end

    it 'should return nil if the round is greater than the number of prompts' do
      game = create(:game, :with_prompts, room_code: 'PIZZA', round: 100)

      expect(game.current_prompt).to be_nil
    end

    it 'should return the prompt for the current round' do
      game = create(:game, :with_prompts, room_code: 'PIZZA', round: 1)

      expect(game.current_prompt).to eq(game.prompts[0])

      game.update(round: 2)

      expect(game.current_prompt).to eq(game.prompts[1])

      game.update(round: 3)

      expect(game.current_prompt).to eq(game.prompts[2])
    end
  end
end
