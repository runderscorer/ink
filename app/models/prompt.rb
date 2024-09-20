# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prompt < ApplicationRecord
  has_many :game_prompts
  has_many :games, through: :game_prompts
  has_many :responses
end
