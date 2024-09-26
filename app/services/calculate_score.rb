class CalculateScore < BaseService
  def call
    return fail!('Game not found') if game.blank?
    return fail!('No prompt found') if game.current_prompt.blank?
    return fail!('No votes found') if game.current_prompt.votes.by_game(game.room_code).blank?

    calculate_score

    self
  end

  private

  def calculate_score
    game.current_prompt.votes.by_game(game.room_code).each do |vote|
      if vote.response.correct?
        vote.player.increment!(:score, 300)
      else
        vote.response.player.increment!(:score, 100)
      end
    end
  end
end
