class InitializeGame
  def self.call(game)
    game.start!
    game.get_prompts!
  end
end