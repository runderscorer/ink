class InitializeGame < BaseService
  def call
    return fail!('Game not found') if game.blank?
    return fail!('Game already started') if game.started_at.present?
    return fail!('Game requires at least 2 poets') if game.players.count < 2

    initialize_game

    self
  end

  private

  def initialize_game
    game.start!
    game.assign_prompts!
    game.set_round_ends_at

    ActionCable.server.broadcast(game.room_code, {
      type: 'GAME_STARTED',
      game: GameSerializer.new(game).serializable_hash
    })
  rescue StandardError => e
    fail!(e.message)
  end
end