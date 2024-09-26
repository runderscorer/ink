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

    handle_all_votes_submitted if all_votes_submitted? 

    render status: :ok
  end

  private

  def all_votes_submitted?
    @game.current_prompt.votes.by_game(@game.room_code).count == @game.players.count
  end

  def handle_all_votes_submitted
    result = CalculateScore.call(game: @game)

    if result.success?
      @game.viewing_scores!
      ActionCable.server.broadcast(@game.room_code, {
        type: 'ROUND_OVER',
        game: GameSerializer.new(@game).serializable_hash
      })
    else
      render json: { error_message: result.error_message }, status: 400
    end
  end
end
