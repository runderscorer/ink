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
class ResponseSerializer
  include JSONAPI::Serializer

  attributes :id, :text, :prompt_id, :game_id, :correct, :player_id, :votes, :player_name

  belongs_to :player
  has_many :votes

  attribute :player_name do |object|
    "#{object.player ? object.player.name : object.prompt.author}"
  end

  attribute :votes do |object, params|
    VoteSerializer.new(object.votes.where(game_id: params[:game_id])).serializable_hash
  end
end
