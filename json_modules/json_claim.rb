require_relative 'json_elements'

module JsonClaim
	include JsonElements

	def self.build_json_claim(claim)
		json_claim = JsonElements.add_json_element({}.to_json, JsonElements.amount)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.payment)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.timeline)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.interest)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.claimants)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.defendants)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.reason)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.timeline)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.evidence)
		json_claim = JsonElements.add_json_element(json_claim, JsonElements.fee_amount_in_pennies)
		json_claim
	end

end