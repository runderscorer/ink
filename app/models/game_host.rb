class GameHost < ApplicationRecord
  belongs_to :game, dependent: :destroy
  belongs_to :player
end
