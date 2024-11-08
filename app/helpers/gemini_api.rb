class GeminiApi
  include HTTParty
  
  def initialize(poem_prompt)
    @headers = {'Content-Type' => 'application/json'}
    @text = "Write an original two line response to the following excerpt of a poem: \n
             Poem Excerpt: #{poem_prompt}"
  end

  def generate_response
    response = fetch_response

    response.gsub('\n', '') if response
  end

  private

  def fetch_response
    response = self.class.post(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{ENV['GEMINI_API_KEY']}",
      body: {
        contents: [
          parts: [
            {
              text: @text
            }
          ]
        ]
      }.to_json,
      headers: @headers
    )

    json_response = JSON.parse(response)
    json_response.dig('candidates', 0, 'content', 'parts', 0, 'text')
  end
end