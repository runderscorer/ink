# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE)
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  status     :integer          default("waiting")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
require 'rails_helper'

RSpec.describe 'Game', type: :model do
  context 'validations' do
    describe 'room_code' do
      it 'should validate the uniqueness of a room_code and the archived status' do
        create(:game, room_code: 'TAKEN')
        game = build(:game, room_code: 'taken')
        game.save

        expect(game.errors.full_messages.last).to eq('Room code has already been taken')

        create(:game, room_code: 'ARCHIVED', archived: true)
        game = build(:game, room_code: 'ARCHIVED')
        game.save

        expect(game.valid?).to be true
      end

      it 'should validate the presence of a room_code' do
        game = build(:game, room_code: nil)
        game.save

        expect(game.errors.full_messages.last).to eq("Room code can't be blank")
      end

      it 'should validate the length of a room_code' do
        game = build(:game, room_code: 'SH')
        game.save

        expect(game.errors.full_messages.last).to eq('Room code is too short (minimum is 3 characters)')

        game = build(:game, room_code: 'ROOMCODEISTOOLONG')
        game.save

        expect(game.errors.full_messages.last).to eq('Room code is too long (maximum is 10 characters)')
      end

      it 'should validate the format of a room_code' do
        game = build(:game, room_code: '#ROOM!CODE')
        game.save

        expect(game.errors.full_messages.last).to eq('Room code must not include special characters')
      end
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

  context 'next_status!' do
    describe 'when waiting' do
      it 'should update the status to gathering_responses' do
        game = create(:game)

        game.next_status!

        expect(game.status).to eq('gathering_responses')
      end
    end

    describe 'when gathering_responses' do
      it 'should update the status to gathering_votes' do
        game = create(:game, :gathering_responses)

        game.next_status!

        expect(game.status).to eq('gathering_votes')
      end
    end

    describe 'when gathering_votes' do
      it 'should update the status to viewing_scores' do
        game = create(:game, :with_prompts, :gathering_votes)

        game.next_status!

        expect(game.status).to eq('viewing_scores')
      end
    end

    describe 'when viewing_scores' do
      describe 'and the round is less than the max rounds' do
        it 'should update the status to gathering_responses' do
          game = create(:game, :with_prompts, :viewing_scores)

          game.next_status!

          expect(game.status).to eq('gathering_responses')
        end
      end

      describe 'and the round is equal to the max rounds' do
        it 'should update the status to game_over' do
          game = create(:game, :with_prompts, :viewing_scores, round: Game::MAX_ROUNDS)

          game.next_status!

          expect(game.status).to eq('game_over')
        end
      end
    end
  end

  describe '#archive!' do
    it 'should update the archived status to true' do
      game = create(:game, archived: false)

      game.archive!

      expect(game.archived).to be true
    end
  end
end
