class Game < ApplicationRecord
  validates_uniqueness_of :room_code
  validates_presence_of :room_code
end
