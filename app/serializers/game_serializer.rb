# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
class GameSerializer
  include JSONAPI::Serializer

  attributes :room_code, :host, :started_at, :current_prompt, :round, :status, :max_rounds

  has_many :players
  has_many :prompts

  attribute :players do |object|
    PlayerSerializer.new(object.players).serializable_hash
  end

  attribute :player_names do |object|
    object.players.pluck(:name)
  end

  attribute :current_prompt, if: Proc.new { |record| record.current_prompt.present? } do |object|
    { 
      id: object.current_prompt.id, 
      text: object.current_prompt.text, 
      author: object.current_prompt.author,
      responses: ResponseSerializer.new(object.current_prompt.responses.by_game(object.room_code)).serializable_hash,
      votes: VoteSerializer.new(object.current_prompt.votes.by_game(object.room_code)).serializable_hash
    }
  end

  attribute :max_rounds do |object|
    Game::MAX_ROUNDS
  end

  attribute :winners, if: Proc.new { |record| record.game_over? } do |object|
    high_score = object.players.pluck(:score).max

    object.players.where(score: high_score) 
  end
end
