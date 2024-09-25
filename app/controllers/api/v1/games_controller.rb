class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:search, :start]

  def create
    room_code = game_attributes[:room_code] || Random.alphanumeric.first(6)
    @game = Game.create(room_code: room_code)

    render json: { errors: @game.errors.full_messages }, status: 400 and return unless @game.valid?

    set_host if params[:host_name]

    render json: GameSerializer.new(@game).serializable_hash, status: :ok
  end

  def search
    render json: GameSerializer.new(@game).serializable_hash, status: :ok
  end

  def start
    result = InitializeGame.call(game: @game)

    if result.success?
      broadcast_start_game

      render status: :ok
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end

  private

  def game_attributes
    params.permit(:room_code)
  end

  def set_host
    Player.create(name: params[:host_name], game_id: @game.id, host: true)
  end

  def broadcast_start_game
    ActionCable.server.broadcast(@game.room_code, {
      type: 'GAME_STARTED',
      game: GameSerializer.new(@game).serializable_hash
    })
  end
end
