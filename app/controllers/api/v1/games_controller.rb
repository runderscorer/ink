class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:search]

  def create
    room_code = game_attributes[:room_code] || Random.alphanumeric.first(6)
    @game = Game.create(room_code: room_code)

    render json: { errors: @game.errors.full_messages }, status: 400 and return unless @game.valid?

    add_host if params[:host_name]

    render json: GameSerializer.new(@game), status: :ok
  end

  def search
    render json: GameSerializer.new(@game), status: :ok
  end

  private

  def game_attributes
    params.permit(:room_code)
  end

  def add_host
    player = Player.create(name: params[:host_name], game_id: @game.id)
    GameHost.create!(game_id: @game.id, player_id: player.id)
  end
end
