# == Schema Information
#
# Table name: responses
#
#  id         :bigint           not null, primary key
#  correct    :boolean          default(FALSE)
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  belongs_to :prompt
end
