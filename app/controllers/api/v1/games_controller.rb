class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:search]

  def create
    room_code = game_attributes[:room_code] || Random.alphanumeric.first(6)
    game = Game.create(room_code: room_code)

    render json: { errors: game.errors.full_messages }, status: 400 and return unless game.valid?

    render json: GameSerializer.new(game), status: :ok
  end

  def search
    render json: GameSerializer.new(@game), status: :ok
  end

  private

  def game_attributes
    params.permit(:room_code)
  end
end
