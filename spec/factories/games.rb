# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
FactoryBot.define do
  factory :game do
    room_code { Faker::App.name }
  end

  trait :with_prompts do
    started_at { Time.zone.now }
    round      { 1 }

    after(:create) do |game|
      create_list(:prompt, 3).each do |prompt|
        create(:game_prompt, game: game, prompt: prompt)
      end
    end
  end
end
