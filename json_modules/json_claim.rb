require_relative 'json_elements'
require_relative 'json_claim_elements'

module JsonClaim
	include JsonElements

	def self.build_json_blob(claim)
		[
			JsonClaimElements.amount,
			JsonClaimElements.payment,
			JsonClaimElements.timeline,
			JsonClaimElements.interest,
			JsonClaimElements.claimants,
			JsonClaimElements.defendants,
			JsonClaimElements.reason,
			JsonClaimElements.timeline,
			JsonClaimElements.evidence,
			JsonClaimElements.fee_amount_in_pennies
		]
	end

end