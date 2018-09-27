require_relative 'json_claim'
require_relative 'json_defendant_response'
require_relative 'json_claimant_response'

module JsonResponseBody
  include JsonClaim
  include JsonDefendantResponse
  include JsonClaimantResponse

  def self.json_response_body(journey, journey_data)
    json_elements = response_module(journey).build_json_blob(journey_data)
    collate_json_elements(json_elements)
  end

  def self.response_module(journey)
    {
      claim: JsonClaim,
      defendant_response: JsonDefendantResponse,
      claimant_response: JsonClaimantResponse
    }[journey]
  end

  def self.collate_json_elements(array_spec)
    json_blob = {}.to_json
    array_spec.each do |json_element|
      json_blob = JSON.parse(json_blob).merge(JSON.parse(json_element)).to_json
    end
    json_blob
  end

end