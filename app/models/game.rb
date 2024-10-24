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
class Game < ApplicationRecord
  MAX_ROUNDS = 3

  before_validation :normalize_room_code, if: -> { room_code.present? }

  validates :room_code, format: { with: /\A[\w\_]+\z/, message: 'must not include special characters' }, length: { minimum: 3, maximum: 10 }, presence: true
  validates_uniqueness_of :room_code, scope: :archived, conditions: -> { where(archived: false) }

  has_many :players, dependent: :destroy
  has_many :game_prompts, dependent: :destroy
  has_many :prompts, through: :game_prompts
  has_many :votes, dependent: :destroy

  enum status: { 
    waiting: 0, 
    gathering_responses: 1, 
    gathering_votes: 2,
    viewing_scores: 3,
    game_over: 4
  }

  def host
    players.find_by(host: true)
  end

  def assign_new_host(current_host)
    archive! and return if players.where(host: false).blank?

    players.where.not(id: current_host.id).sample.update(host: true)
    self
  end

  def start!
    update(
      started_at: Time.zone.now, 
      round: 1,
      status: :gathering_responses
    )
  end

  def assign_prompts!
    Prompt.all.sample(MAX_ROUNDS).each do |prompt|
      game_prompts.create(prompt: prompt)
    end
  end

  def current_prompt
    return if prompts.blank? || round.nil?

    prompts[(round % MAX_ROUNDS) - 1]
  end

  def next_status!
    case true
    when waiting?
      gathering_responses!
    when gathering_responses?
      gathering_votes!
      update(status: :gathering_votes)
    when gathering_votes?
      viewing_scores!
    when viewing_scores? && round < MAX_ROUNDS
      gathering_responses!
    else
      game_over!
    end
  end

  def restart!
    game_prompts.destroy_all      
    Vote.by_game(room_code).destroy_all
    players.update_all(score: 0)
    Response.where(game_id: id).update_all(archived: true)
    assign_prompts!
    update!(status: :gathering_responses, round: round + 1)
  end

  def archive!
    update!(archived: true)
  end

  def most_liked
    players
      .joins(responses: :reactions)
      .where(reactions: { kind: 'like' })
      .group('players.id')
      .select('players.id, players.name, COUNT(reactions.id) as reaction_count')
      .order('reaction_count DESC')
      .limit(1)
      .first
  end

  def funniest
    players
      .joins(responses: :reactions)
      .where(reactions: { kind: 'funny' })
      .group('players.id')
      .select('players.id, players.name, COUNT(reactions.id) as reaction_count')
      .order('reaction_count DESC')
      .limit(1)
      .first
  end

  def smartest
    players
      .joins(responses: :reactions)
      .where(reactions: { kind: 'smart' })
      .group('players.id')
      .select('players.id, players.name, COUNT(reactions.id) as reaction_count')
      .order('reaction_count DESC')
      .limit(1)
      .first
  end

  def self.by_room_code(room_code)
    find_by(room_code: room_code, archived: false)
  end

  private

  def normalize_room_code
    self.room_code = room_code.upcase
    self.room_code = room_code.gsub(/\s+/, '')
  end 
end
