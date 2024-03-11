class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:search]

  def create
    room_code = params[:room_code] || Random.alphanumeric.first(6)
    game = Game.create(room_code: room_code)

    render json: { errors: game.errors.full_messages }, status: 400 and return unless game.valid?

    render json: GameSerializer.new(game), status: :ok
  end

  def search
    render json: GameSerializer.new(@game), status: :ok
  end

  private

  def find_game
    render json: { errors: 'Enter a room code.' }, status: :ok and return unless params[:room_code]

    @game = Game.find_by room_code: params[:room_code].upcase

    render json: { errors: 'Game not found. Please try another room code.' }, status: :not_found and return unless @game
  end
end
