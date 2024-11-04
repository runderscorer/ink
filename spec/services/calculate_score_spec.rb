require 'rails_helper'

RSpec.describe 'CalculateScore', type: :service do
  describe 'call' do
    it 'should return an error message if the game is not found' do
      result = CalculateScore.call(game: nil)

      expect(result.success?).to be false
      expect(result.error_message).to eq('Game not found')
    end

    it 'should return an error message if a current prompt is not found' do
      game = create(:game)
      result = CalculateScore.call(game: game)

      expect(result.success?).to be false
      expect(result.error_message).to eq('No prompt found')
    end

    it 'should return an error message if no votes are found' do
      game = create(:game, :with_prompts)
      result = CalculateScore.call(game: game)

      expect(result.success?).to be false
      expect(result.error_message).to eq('No votes found')
    end

    it 'should calculate the score for all players based on the current prompt' do
      game = create(:game, :with_prompts)
      ken = create(:player, game: game)
      ryu = create(:player, game: game)

      prompt = game.current_prompt
      correct_response = prompt.responses.find_by(correct: true)
      ken_response = prompt.responses.create(player: ken, text: 'Shoryuken')
      ryu_response = prompt.responses.create(player: ryu, text: 'Hadouken')

      create(:vote, response: correct_response, player: ryu, game: game)
      create(:vote, response: ryu_response, player: ken, game: game)

      result = CalculateScore.call(game: game)

      expect(result.success?).to be true
      expect(ken.reload.score).to eq(0)
      expect(ryu.reload.score).to eq(400)

      game.update!(round: 2)

      prompt = game.current_prompt
      correct_response = prompt.responses.find_by(correct: true)
      ken_response = prompt.responses.create(player: ken, text: 'Shoryuken Championship Edition')
      ryu_response = prompt.responses.create(player: ryu, text: 'Hadouken Championship Edition')

      create(:vote, response: correct_response, player: ken, game: game)
      create(:vote, response: correct_response, player: ryu, game: game)

      result = CalculateScore.call(game: game)

      expect(result.success?).to be true
      expect(ken.reload.score).to eq(300)
      expect(ryu.reload.score).to eq(700)

      game.update!(round: 3)

      prompt = game.current_prompt
      correct_response = prompt.responses.find_by(correct: true)
      ken_response = prompt.responses.create(player: ken, text: 'Shoryuken Turbo Edition')
      ryu_response = prompt.responses.create(player: ryu, text: 'Hadouken Turbo Edition')

      create(:vote, response: ryu_response, player: ken, game: game)
      create(:vote, response: ken_response, player: ryu, game: game)

      result = CalculateScore.call(game: game)

      expect(result.success?).to be true
      expect(ken.reload.score).to eq(400)
      expect(ryu.reload.score).to eq(800)
    end
  end
end
