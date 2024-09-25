class Api::V1::VotesController < ApplicationController
  before_action :find_game, only: [:create]

  def create
    vote = Vote.create(
      response_id: params[:response_id],
      player_id: params[:player_id]
    )

    render json: { 
      vote: VoteSerializer.new(vote).serializable_hash, 
      game: GameSerializer.new(@game).serializable_hash 
    }, status: :ok
  end
end
