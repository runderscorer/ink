class GameChannel < ApplicationCable::Channel
  attr_accessor :player_id

  def subscribed
    room_code = params[:room_code]
    stream_from room_code

    game = Game.find_by(room_code: room_code)

    if game
      ActionCable.server.broadcast(room_code, { type: 'GAME_FOUND', game: GameSerializer.new(game).serializable_hash })
    end
  end

  def unsubscribed
    player = Player.find_by(id: @player_id)
    return if player.blank?

    player.destroy

    game = Game.find_by(room_code: params[:room_code])
    return if game.blank?

    game.destroy && return if game.players.blank?

    ActionCable.server.broadcast(room_code, { type: 'PLAYER_LEFT', game: GameSerializer.new(game).serializable_hash })

    stop_stream_from params[:room_code]
  end

  def set_player_id(data)
    @player_id = data['player_id']
  end
end
