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
    it 'should set the started_at date, round, and status' do
      game = create(:game, started_at: nil, round: nil, status: Game.statuses[:waiting])

      game.start!

      expect(game.started_at).to be_present
      expect(game.round).to eq(1)
      expect(game.status).to eq('gathering_responses')
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

  context 'statuses' do
    before do
      @game = create(:game)
    end

    describe 'gathering_responses' do
      it 'should update the status to gathering_responses' do
        expect(@game.status).to eq('waiting') 

        @game.gathering_responses!

        expect(@game.status).to eq('gathering_responses')
      end
    end

    describe 'gathering_votes' do
      it 'should update the status to gathering_votes' do
        expect(@game.status).to eq('waiting') 

        @game.gathering_votes!

        expect(@game.status).to eq('gathering_votes')
      end
    end
  end
end
