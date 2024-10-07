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
  include CopyHelper

  validates :name, presence: true, length: { maximum: 10 }
  validates_each :game_id, on: :create do |record, _attr, value|
    record.errors.add(:base, 'Sorry, this game is full (8 players)') if Game.find(value).players.count >= 8
  end

  belongs_to :game
  has_many :responses, dependent: :destroy
  has_many :votes, dependent: :destroy
end
