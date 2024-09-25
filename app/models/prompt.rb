# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  author     :string
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Prompt < ApplicationRecord
  has_many :game_prompts
  has_many :games, through: :game_prompts, dependent: :destroy
  has_many :responses
  has_many :votes, through: :responses
end
