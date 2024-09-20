# == Schema Information
#
# Table name: game_prompts
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  prompt_id  :bigint           not null
#
# Indexes
#
#  index_game_prompts_on_game_id    (game_id)
#  index_game_prompts_on_prompt_id  (prompt_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (prompt_id => prompts.id)
#
class GamePrompt < ApplicationRecord
end

