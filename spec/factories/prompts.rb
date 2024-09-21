FactoryBot.define do
  factory :prompt do
    text { Faker::Fantasy::Tolkien.poem }

    after(:create) do |prompt|
      create(:response, prompt: prompt)
    end
  end
end

