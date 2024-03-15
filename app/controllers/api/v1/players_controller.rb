class Api::V1::PlayersController < ApplicationController
  before_action :find_game, only: [:create, :destroy]

  def create
    player = Player.create(name: player_attributes[:name], game_id: @game.id)

    render json: { errors: player.errors.full_messages }, status: 400 and return unless player.valid?

    ActionCable.server.broadcast(@game.room_code, { 
      type: 'PLAYER_JOINED', 
      game: GameSerializer.new(@game)
    })

    render json: PlayerSerializer.new(player), status: :ok
  end

  def update
    player = Player.find(params[:id])
    player.update(name: player_attributes[:name])

    render json: { errors: player.errors.full_messages }, status: 400 and return unless player.valid?

    render json: PlayerSerializer.new(player), status: :ok
  end

  def destroy
    player = Player.find_by(id: params[:id], game_id: @game.id)

    render json: { errors: 'Player was not removed.' }, status: :ok and return unless player

    player.destroy

    ActionCable.server.broadcast(@game.room_code, { 
      type: 'PLAYER_LEFT', 
      game: GameSerializer.new(@game)
    })

    render json: { message: 'Player has been removed.' }, status: :ok
  end

  private

  def player_attributes
    params.require(:player).permit(:name, :room_code)
  end
end
