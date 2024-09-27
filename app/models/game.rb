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
class Game < ApplicationRecord
  MAX_ROUNDS = 3

  before_validation :normalize_room_code, if: -> { room_code.present? }

  validates :room_code, format: { with: /\A[\w\_]+\z/, message: 'must not include special characters' }, length: { minimum: 3, maximum: 10 }, presence: true
  validates_uniqueness_of :room_code

  has_many :players, dependent: :destroy
  has_many :game_prompts, dependent: :destroy
  has_many :prompts, through: :game_prompts

  enum status: { 
    waiting: 0, 
    gathering_responses: 1, 
    gathering_votes: 2,
    viewing_scores: 3
  }

  def host
    players.find_by(host: true)
  end

  def assign_new_host(current_host)
    destroy and return if players.where(host: false).blank?

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
    return if prompts.blank? || round.nil? || round > prompts.count

    prompts[round - 1]
  end

  private

  def normalize_room_code
    self.room_code = room_code.upcase
    self.room_code = room_code.gsub(/\s+/, '')
  end 
end
