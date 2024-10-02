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
class PromptSerializer
  include JSONAPI::Serializer

  attributes :text, :author, :responses, :title

  has_many :responses
end
