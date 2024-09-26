class InitializeGame < BaseService
  def call
    return fail!('Game not found') if game.blank?
    return fail!('Game already started') if game.started_at.present?

    initialize_game

    self
  end

  private

  def initialize_game
    game.start!
    game.assign_prompts!
  rescue StandardError => e
    fail!(e.message)
  end
end