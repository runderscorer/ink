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
class GameSerializer
  include JSONAPI::Serializer

  attributes :room_code, :host, :started_at, :prompts

  has_many :players
  has_many :prompts

  attribute :player_names do |object|
    object.players.pluck(:name)
  end
end
