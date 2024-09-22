class PromptSerializer
  include JSONAPI::Serializer

  attributes :text, :author, :responses

  has_many :responses
end
