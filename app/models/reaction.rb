# == Schema Information
#
# Table name: reactions
#
#  id          :bigint           not null, primary key
#  kind        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  player_id   :bigint
#  response_id :bigint
#
# Indexes
#
#  index_reactions_on_player_id    (player_id)
#  index_reactions_on_response_id  (response_id)
#
class Reaction < ApplicationRecord
  belongs_to :player
  belongs_to :response

  enum kind: { 
    like: 0,
    funny: 1,
    smart: 2
  }
end
