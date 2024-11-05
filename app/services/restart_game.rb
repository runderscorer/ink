class RestartGame < BaseService
  def call
    return fail!('Game not found') if game.blank?
    return fail!('Game not started') if game.started_at.blank?
    return fail!('Host not found') if player.blank? || game.host.blank?
    return fail!('Only the host can start the next round') if player != game.host
    return fail!('At least 2 poets are required to restart the game') if game.players.count < 2

    restart_game

    self
  end

  private

  def restart_game
    game.restart!
    game.set_round_ends_at

    ActionCable.server.broadcast(game.room_code, {
      type: 'GAME_STARTED',
      game: GameSerializer.new(game).serializable_hash
    })
  rescue StandardError => e
    return fail!(e.message)
  end
end
