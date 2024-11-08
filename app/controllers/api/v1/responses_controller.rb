class Api::V1::ResponsesController < ApplicationController
  before_action :find_game, only: [:create]

  def create
    if @game.current_prompt.blank?
      render json: { error_message: 'There was an error submitting your response' }, status: 400
    else
      response = @game.current_prompt.responses.create(
        player_id: params[:player_id],
        game_id: @game.id,
        text: params[:help] ? use_gen_ai_response : params[:text]
      )

      ActionCable.server.broadcast(@game.room_code, {
        type: 'NEW_RESPONSE',
        game: GameSerializer.new(@game).serializable_hash
      })

      handle_all_responses_submitted if all_responses_submitted?

      render status: :ok
    end
  end

  private

  def all_responses_submitted?
    @game.current_prompt.responses.by_game(@game.room_code).count == @game.players.count + 1
  end

  def handle_all_responses_submitted
    @game.next_status!

    ActionCable.server.broadcast(@game.room_code, {
      type: 'ALL_RESPONSES_SUBMITTED',
      game: GameSerializer.new(@game).serializable_hash
    })
  end

  def use_gen_ai_response
    return unless @game.current_prompt

    gen_ai = GeminiApi.new(@game.current_prompt.text)

    gen_ai.generate_response
  end
end
