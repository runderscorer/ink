# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  host       :boolean          default(FALSE)
#  name       :string           not null
#  score      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#
class Player < ApplicationRecord
  validates_presence_of :name

  belongs_to :game
  has_many :responses, dependent: :destroy
  has_many :votes, dependent: :destroy
end
