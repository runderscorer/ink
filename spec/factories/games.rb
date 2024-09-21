# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  ended_at   :datetime
#  room_code  :string           not null
#  started_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  winner_id  :integer
#
FactoryBot.define do
  factory :game do
    room_code { Faker::App.name }
  end
end
