# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
class Game < ApplicationRecord
  before_validation :normalize_room_code, if: -> { room_code.present? }

  validates_presence_of :room_code
  validates_uniqueness_of :room_code

  has_many :players, dependent: :destroy
  has_many :game_prompts
  has_many :prompts, through: :game_prompts

  def host
    players.find_by(host: true)
  end

  def assign_new_host(current_host)
    destroy and return if players.where(host: false).blank?

    players.where.not(id: current_host.id).sample.update(host: true)
    self
  end

  def start!
    update(started_at: Time.zone.now)
  end

  def assign_prompts!
    Prompt.all.sample(3).each do |prompt|
      game_prompts.create(prompt: prompt)
    end
  end

  private

  def normalize_room_code
    self.room_code = room_code.upcase
  end 
end
