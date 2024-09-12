class Game < ApplicationRecord
  before_validation :normalize_room_code, if: -> { room_code.present? }

  validates_presence_of :room_code
  validates_uniqueness_of :room_code

  has_many :players, dependent: :destroy

  def host
    players.find_by(host: true)
  end

  def assign_new_host(current_host)
    destroy and return if players.where(host: false).blank?

    players.where.not(id: current_host.id).sample.update(host: true)
    self
  end

  private

  def normalize_room_code
    self.room_code = room_code.upcase
  end 
end
