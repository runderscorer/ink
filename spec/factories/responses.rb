FactoryBot.define do
  factory :response do
    text { Faker::Fantasy::Tolkien.poem }
    prompt
  end
end