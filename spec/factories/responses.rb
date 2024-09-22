# == Schema Information
#
# Table name: responses
#
#  id         :bigint           not null, primary key
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
FactoryBot.define do
  factory :response do
    text { Faker::Fantasy::Tolkien.poem }
    prompt
  end
end
