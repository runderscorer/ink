class AdvanceRound < BaseService
  def call
    return fail!('Game not found') if game.blank?
    return fail!('Game not started') if game.started_at.blank?
    return fail!('Host not found') if player.blank? || game.host.blank?
    return fail!('Only the host can start the next round') if player != game.host

    advance_round

    self
  end

  private

  def advance_round
    game.next_status!
    game.increment!(:round) unless game.final_round?

    ActionCable.server.broadcast(game.room_code, {
      type: 'NEXT_ROUND',
      game: GameSerializer.new(game).serializable_hash
    })
  end
end
