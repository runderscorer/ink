class Game < ApplicationRecord
  validates_uniqueness_of :room_code
  validates_presence_of :room_code

  before_save :normalize_room_code

  has_many :players, dependent: :destroy

  def host
    players.find_by(host: true)
  end

  private

  def normalize_room_code
    self.room_code = room_code.upcase
  end 
end
