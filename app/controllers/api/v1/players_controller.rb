class Api::V1::PlayersController < ApplicationController
  before_action :find_game, only: [:create]

  def create
    player = Player.create(name: player_attributes[:name], game_id: @game.id)

    render json: { errors: player.errors.full_messages }, status: 400 and return unless player.valid?

    render json: PlayerSerializer.new(player), status: :ok
  end

  def update
    player = Player.find(params[:id])
    player.update(name: player_attributes[:name])

    render json: { errors: player.errors.full_messages }, status: 400 and return unless player.valid?

    render json: PlayerSerializer.new(player), status: :ok
  end

  private

  def player_attributes
    params.require(:player).permit(:name, :room_code)
  end
end
