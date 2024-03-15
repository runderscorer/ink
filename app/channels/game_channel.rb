class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from params[:room_code]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_stream_from params[:room_code]
  end
end
