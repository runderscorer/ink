# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  round      :integer
#  started_at :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
FactoryBot.define do
  factory :game do
    room_code { "#{Faker::App.name}#{1.upto(10).to_a.sample}" }
  end

  trait :with_prompts do
    started_at { Time.zone.now }
    round      { 1 }
    status     { :gathering_responses }

    after(:create) do |game|
      create_list(:prompt, 3).each do |prompt|
        create(:game_prompt, game: game, prompt: prompt)
        create(:response, :correct, prompt: prompt)
      end
    end
  end

  trait :gathering_responses do
    status { :gathering_responses}
  end

  trait :gathering_votes do
    status { :gathering_votes}
  end
end
