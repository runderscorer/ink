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
class PromptSerializer
  include JSONAPI::Serializer

  attributes :text, :author, :responses

  has_many :responses
end
