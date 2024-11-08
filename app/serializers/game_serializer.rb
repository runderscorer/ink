# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE)
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  status     :integer          default("waiting")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
class GameSerializer
  include JSONAPI::Serializer

  attributes :room_code, :host, :started_at, :current_prompt, :round, :status, :max_rounds, :round_ends_at

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
      title: object.current_prompt.title,
      responses: ResponseSerializer.new(object.current_prompt.responses.by_game(object.room_code), params: { game_id: object.id }).serializable_hash,
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

  attribute :not_winners, if: Proc.new { |record| record.game_over? } do |object|
    high_score = object.players.pluck(:score).max

    object.players.where.not(score: high_score).order(score: :desc)
  end

  attribute :most_liked, if: Proc.new { |record| record.game_over? } do |object|
    most_liked = object.most_liked

    { name: most_liked.name, count: most_liked.reaction_count, title: most_liked.most_liked_title } if most_liked.present?
  end

  attribute :funniest, if: Proc.new { |record| record.game_over? } do |object|
    funniest = object.funniest

    { name: funniest.name, count: funniest.reaction_count, title: funniest.funniest_title } if funniest.present?
  end

  attribute :smartest, if: Proc.new { |record| record.game_over? } do |object|
    smartest = object.smartest

    { name: smartest.name, count: smartest.reaction_count, title: smartest.smartest_title } if smartest.present?
  end

  attribute :round_ends_at do |object|
    Rails.cache.fetch("#{object.room_code}_round_ends_at")
  end
end
