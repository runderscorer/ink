class Game < ApplicationRecord
  validates_uniqueness_of :room_code
  validates_presence_of :room_code

  before_save :normalize_room_code

  has_many :players, dependent: :destroy
  has_one :game_host, dependent: :destroy
  has_one :host, through: :game_host, source: :player

  private

  def normalize_room_code
    self.room_code = room_code.upcase
  end 
end
