module JsonClaimantResponseElements


  def self.accept_response
    {
      "type": "acceptation"
    }.to_json
  end

  def self.reject_response
    {
      "type": "rejection"
    }.to_json
  end

  def self.accept_plan(args = {})
    formalise_option = {
      settlement: "SETTLEMENT",
      ccj: "CCJ"
    }[args[:formalise_option] || :settlement]
    {
      "formaliseOption": formalise_option,
      "decisionType": "DEFENDANT"
    }.to_json
  end

  def self.reject_plan(args = {})
    json_rejection = claimant_plan(args)
    json_rejection.update(court_plan(args)) if args[:rejection_type] == :court
    json_rejection.to_json
  end

  # def self.agree_paid
  #
  # end
  #
  # def self.refute_paid
  #
  # end

  def self.reject_reduction_reason
    {
      "reason": "text representing reason for rejecting reduction"
    }.to_json
  end

  def self.amount_paid(args = {})
    {
      "amountPaid": args[:amount_paid] || 0
    }.to_json
  end

  def self.court_plan(args = {})
    {
      "courtDetermination": {
        "courtDecision": repayment_plan(args[:court_plan]),
        "disposableIncome": 2000
      }
    }
  end

  def self.claimant_plan(args = {})
    {
      "claimantPaymentIntention": repayment_plan(args[:claimant_plan] || {})
    }
  end

  def self.repayment_plan(args = {})
    plan_type = args[:plan_type] || :by_set_date
    case plan_type
    when :by_set_date
      by_set_date
    when :instalments
      instalments
    end
  end

  def self.by_set_date
    {
      "paymentOption": "BY_SPECIFIED_DATE",
      "paymentDate": "2019-10-27"
    }
  end

  def self.instalments
    {
      "paymentOption": "INSTALMENTS",
      "repaymentPlan": {
        "instalmentAmount": 400,
        "firstPaymentDate": "2018-10-27",
        "paymentSchedule": "EACH_WEEK"
      }
    }
  end

end