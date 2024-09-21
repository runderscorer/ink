# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  text       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :prompt do
    text { Faker::Fantasy::Tolkien.poem }

    after(:create) do |prompt|
      create(:response, prompt: prompt)
    end
  end
end

