# == Schema Information
#
# Table name: responses
#
#  id         :bigint           not null, primary key
#  archived   :boolean          default(FALSE)
#  correct    :boolean          default(FALSE)
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :integer
#  player_id  :bigint
#  prompt_id  :integer
#
# Indexes
#
#  index_responses_on_player_id  (player_id)
#
# Foreign Keys
#
#  fk_rails_...  (player_id => players.id)
#
class Response < ApplicationRecord
  belongs_to :game, optional: true
  belongs_to :player, optional: true
  belongs_to :prompt
  has_many :votes
  has_many :reactions

  scope :correct, -> { where(correct: true) }
  scope :not_archived, -> { where(archived: false) }
  scope :by_game, ->(room_code) { not_archived.where(game_id: Game.by_room_code(room_code).id).or(correct).order(text: :asc) }
end
