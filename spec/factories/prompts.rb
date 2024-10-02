# == Schema Information
#
# Table name: prompts
#
#  id         :bigint           not null, primary key
#  author     :string
#  text       :string           not null
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :prompt do
    text   { Faker::Fantasy::Tolkien.poem }
    author { Faker::Fantasy::Tolkien.character }
  end
end

