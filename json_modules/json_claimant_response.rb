require_relative 'json_claimant_response_elements'
require_relative 'json_common_elements'

module JsonClaimantResponse

  def self.build_json_blob(claimant_response)
    case claimant_response
    when :accept_response
      json_accept_reduction
    when :reject_response
      json_reject_reduction
    when :accept_plan
      json_accept_plan
    when :reject_plan
      json_reject_plan
    when :accept_reduction_accept_plan
      json_accept_reduction_accept_plan
    when :accept_reduction_reject_plan
      json_accept_reduction_reject_plan
    when :accept_reduction_agree_paid
      json_accept_reduction_agree_paid
    when :empty_json
      [JsonCommonElements.empty_json]
    # when :agree_paid
    #   json_agree_paid
    # when :refute_paid
    #   json_refute_paid
    # when :accept_repayment_with_ccj
    #   [json_accept_repayment_with_ccj.to_json]
    # when :json_reject_repayment
    #   [json_reject_repayment.to_json]
    else
      raise("no json found for response type: '#{claimant_response}'")
    end
  end

  def self.json_accept_reduction
    [JsonClaimantResponseElements.accept_response]
  end

  def self.json_reject_reduction
    [
      JsonClaimantResponseElements.reject_response,
      JsonClaimantResponseElements.reject_reduction_reason
    ]
  end

  def self.json_accept_plan
    [
      JsonClaimantResponseElements.accept_response,
      JsonClaimantResponseElements.accept_plan
    ]
  end

  def self.json_reject_plan
    [
      JsonClaimantResponseElements.accept_response,
      JsonClaimantResponseElements.reject_plan
    ]
  end

  def self.json_accept_reduction_accept_plan
    [
      JsonClaimantResponseElements.accept_response,
      JsonClaimantResponseElements.accept_plan
    ]
  end

  def self.json_accept_reduction_reject_plan
    [
      JsonClaimantResponseElements.accept_response,
      JsonClaimantResponseElements.reject_plan
    ]
  end

  def self.json_accept_reduction_agree_paid
    [
      JsonClaimantResponseElements.accept_response,
      JsonClaimantResponseElements.agree_paid
    ]
  end



  # def self.json_reject_repayment
  #   {
  #     "type":"rejection"
  #   }
  # end
  #
  # def self.json_accept_repayment_with_ccj
  #   {
  #     "type":"acceptation",
  #     "amountPaid":10,
  #     "claimantPaymentIntention": {
  #       "paymentOption":"IMMEDIATLY"
  #     },
  #     "courtDetermination": {
  #       "courtDecision": {
  #         "paymentOption":"INSTALMENTS"
  #       },
  #       "disposableIncome": 2000
  #     },
  #     "formaliseOption":"SETTLEMENT",
  #     "decisionType": "COURT"
  #   }
  # end
end