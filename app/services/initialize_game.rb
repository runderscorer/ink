class InitializeGame
  def self.call(game)
    return if game.started_at.present?

    game.start!
    game.assign_prompts!
    game
  end
end