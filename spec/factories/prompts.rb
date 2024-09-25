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
FactoryBot.define do
  factory :prompt do
    text   { Faker::Fantasy::Tolkien.poem }
    author { Faker::Fantasy::Tolkien.character }

    after(:create) do |prompt|
      game = create(:game)
      player = create(:player, game: game)
      create(:response, prompt: prompt, game: game, player: player)
    end
  end
end

