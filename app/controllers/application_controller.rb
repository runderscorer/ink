class ApplicationController < ActionController::API

  private

  def find_game
    render json: { errors: 'Enter a room code.' }, status: :ok and return unless params[:room_code]

    @game = Game.by_room_code(params[:room_code].upcase)

    render json: { errors: 'Game not found. Please try another room code.' }, status: :not_found and return unless @game
  end
end
