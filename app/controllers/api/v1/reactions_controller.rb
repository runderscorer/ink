class Api::V1::ReactionsController < ApplicationController
  def create
    reaction = Reaction.create(reaction_params)

    if reaction.persisted?
      render status: :ok
    else
      render json: { error_message: 'There was an error submitting your reaction' }, status: 400
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(%i[kind response_id player_id]) 
  end
end
