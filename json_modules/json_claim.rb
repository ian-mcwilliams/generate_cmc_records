require_relative 'json_elements'
require_relative 'json_claim_elements'

module JsonClaim
	include JsonElements

	def self.build_json_claim(claim)
		json_claim = JsonElements.add_json_element({}.to_json, JsonClaimElements.amount)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.payment)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.timeline)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.interest)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.claimants)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.defendants)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.reason)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.timeline)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.evidence)
		json_claim = JsonElements.add_json_element(json_claim, JsonClaimElements.fee_amount_in_pennies)
		json_claim
	end

end