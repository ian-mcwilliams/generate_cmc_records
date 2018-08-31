require_relative 'json_elements'

module JsonClaim
	include JsonElements

	def self.build_json_claim(claim)
		json_claim = {}.to_json
		json_claim = add_json_claim_element(json_claim, JsonElements.amount)
		json_claim = add_json_claim_element(json_claim, JsonElements.payment)
		json_claim = add_json_claim_element(json_claim, JsonElements.timeline)
		json_claim = add_json_claim_element(json_claim, JsonElements.interest)
		json_claim = add_json_claim_element(json_claim, JsonElements.claimants)
		json_claim = add_json_claim_element(json_claim, JsonElements.defendants)
		json_claim = add_json_claim_element(json_claim, JsonElements.reason)
		json_claim = add_json_claim_element(json_claim, JsonElements.timeline)
		json_claim = add_json_claim_element(json_claim, JsonElements.evidence)
		json_claim = add_json_claim_element(json_claim, JsonElements.fee_amount_in_pennies)
	end

	def self.add_json_claim_element(json_claim, new_element)
		JSON.parse(json_claim).merge(JSON.parse(new_element)).to_json
	end

end