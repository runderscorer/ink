module TestHelpers
  def parse_response
    JSON.parse(response.body)
  end

  def parse_response_attributes
    parse_response['data']['attributes']
  end
end
