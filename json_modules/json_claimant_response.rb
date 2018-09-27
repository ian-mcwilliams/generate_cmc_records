module JsonClaimantResponse
  def self.build_json_claimant_response(claimant_response)
    case claimant_response
    when :accept_repayment_with_ccj
      [json_accept_repayment_with_ccj]
    end
  end

  def self.json_accept_repayment_with_ccj
    {
      "type": "acceptation",
      "amountPaid": 10,
      "claimantPaymentIntention": {
        "paymentOption": "BY_SPECIFIED_DATE",
        "paymentDate": "2018-09-27"
      },
      "formaliseOption": "CCJ"
    }
  end
end