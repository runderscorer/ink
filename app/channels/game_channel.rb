class GameChannel < ApplicationCable::Channel
  attr_accessor :player_id

  def subscribed
    room_code = params[:room_code]
    stream_from room_code

    game = Game.find_by(room_code: room_code)

    if game
      ActionCable.server.broadcast(room_code, { type: 'GAME_FOUND', game: GameSerializer.new(game) })
    end
  end

  def unsubscribed
    Player.find_by(id: @player_id)&.destroy

    room_code = params[:room_code]
    game = Game.find_by(room_code: room_code)

    game.destroy && return if game.players.blank?

    ActionCable.server.broadcast(room_code, { type: 'PLAYER_LEFT', game: GameSerializer.new(game) })

    stop_stream_from params[:room_code]
  end

  def set_player_id(data)
    @player_id = data['player_id']
  end
end
