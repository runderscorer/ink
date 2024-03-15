class GameChannel < ApplicationCable::Channel
  def subscribed
    room_code = params[:room_code]
    stream_from room_code

    game = Game.find_by(room_code: room_code)

    if game
      ActionCable.server.broadcast(room_code, { type: 'GAME_FOUND', game: GameSerializer.new(game) })
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_from params[:room_code]
  end
end
