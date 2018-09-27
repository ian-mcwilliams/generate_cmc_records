require_relative 'json_claim'

module JsonResponseBody

  def self.json_response_body(journey, journey_data)
    case journey
    when :claim
      json_elements = JsonClaim.build_json_claim(journey_data)
    end
    collate_json_elements(json_elements)
  end

  def self.collate_json_elements(array_spec)
    json_blob = {}.to_json
    array_spec.each do |json_element|
      json_blob = JSON.parse(json_blob).merge(JSON.parse(json_element)).to_json
    end
    json_blob
  end

end