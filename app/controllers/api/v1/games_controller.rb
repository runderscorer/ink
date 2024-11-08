class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:search, :start, :next_round, :restart, :timer_end]

  def create
    result = CreateGame.call(room_code: game_attributes[:room_code], host_name: params[:host_name])

    if result.success?
      render json: GameSerializer.new(result.game).serializable_hash, status: :ok
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end

  def search
    render json: GameSerializer.new(@game).serializable_hash, status: :ok
  end

  def start
    result = InitializeGame.call(game: @game)

    if result.success?
      render status: :ok
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end

  def timer_end
    return unless @game.gathering_responses? && @game.players.find_by(id: params[:player_id])

    Game.transaction do 
      @game.lock!

      if @game.next_status!
        ActionCable.server.broadcast(@game.room_code, {
          type: 'ALL_RESPONSES_SUBMITTED',
          game: GameSerializer.new(@game).serializable_hash
        })

        render status: :ok
      else
        render json: { error_message: 'Something went wrong' }, status: 400
      end
    end
  end

  def next_round
    player = Player.find_by(id: params[:player_id])
    result = AdvanceRound.call(game: @game, player: player)

    if result.success?
      render status: :ok
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end

  def restart
    player = Player.find_by(id: params[:player_id])
    result = RestartGame.call(game: @game, player: player)

    if result.success?
      render status: :ok
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end

  private

  def game_attributes
    params.permit(:room_code)
  end
end
