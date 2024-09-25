class Api::V1::VotesController < ApplicationController
  before_action :find_game, only: [:create]

  def create
    vote = Vote.create(
      response_id: params[:response_id],
      player_id: params[:player_id]
    )

    ActionCable.server.broadcast(@game.room_code, {
      type: 'NEW_VOTE',
      game: GameSerializer.new(@game).serializable_hash
    })

    render status: :ok
  end
end
