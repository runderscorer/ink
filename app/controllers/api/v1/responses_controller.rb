class Api::V1::ResponsesController < ApplicationController
  before_action :find_game, only: [:create]

  def create
    if @game.current_prompt.blank?
      render json: { error_message: 'There was an error submitting your response' }, status: 400
    else
      response = @game.current_prompt.responses.create(
        player_id: params[:player_id],
        game_id: @game.id,
        text: params[:text]
      )

      render json: response, status: :ok
    end
  end
end
