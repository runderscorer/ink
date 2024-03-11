class Api::V1::GamesController < ApplicationController
  def create
    room_code = params[:room_code] || Random.alphanumeric.first(6)
    game = Game.create(room_code: room_code)

    render json: { errors: game.errors.full_messages }, status: 400 and return unless game.valid?

    render json: { game: game }, status: :ok
  end
end
