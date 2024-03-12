class Player < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :game_id

  belongs_to :game
end
