class GameChannel < ApplicationCable::Channel
  attr_accessor :player_id

  def subscribed
    room_code = params[:room_code]
    stream_from room_code

    game = Game.by_room_code(room_code)

    if game
      ActionCable.server.broadcast(room_code, { type: 'GAME_FOUND', game: GameSerializer.new(game).serializable_hash })
    end
  end

  def unsubscribed
     # TODO: Use background job with timer to determine if player is still connected
    stop_stream_from params[:room_code]
  end

  def set_player_id(data)
    @player_id = data['player_id']
  end
end
