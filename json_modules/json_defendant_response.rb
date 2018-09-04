require 'date'
require_relative 'json_elements'

module JsonDefendantResponse
  include JsonElements

  def self.build_json_defendant_response(defendant_response)
    case defendant_response
    when :full_admission_immediate
      json_full_admission_immediate
    when :full_admission_by_set_date
      json_full_admission_by_set_date
    when :full_admission_instalments
      json_full_admission_instalments
    when :states_paid
      json_states_paid
    when :part_admission_immediately
      json_part_admission_immediately
    when :part_admission_by_set_date
      json_part_admission_by_set_date
    when :part_admission_instalments
      json_part_admission_instalments
    when :reject_dispute_full_amount
      json_reject_dispute_full_amount
    end
  end

  def self.json_full_admission_immediate
    json_defendant_response = JsonElements.add_json_element({}.to_json, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:immediately))
    json_defendant_response
  end

  def self.json_full_admission_by_set_date
    json_defendant_response = JsonElements.add_json_element({}.to_json, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:by_set_date))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, statement_of_means)
    json_defendant_response
  end

  def self.json_full_admission_instalments
    json_defendant_response = JsonElements.add_json_element({}.to_json, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:by_set_date))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, statement_of_means)
    json_defendant_response
  end

  def self.json_states_paid
    json_defendant_response = JsonElements.add_json_element({}.to_json, evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defence_type(:states_paid))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:full_defence))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_declaration)
    json_defendant_response
  end

  def self.json_part_admission_immediately
    json_defendant_response = JsonElements.add_json_element({}.to_json, amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:immediately))
    json_defendant_response
  end

  def self.json_part_admission_by_set_date
    json_defendant_response = JsonElements.add_json_element({}.to_json, amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:by_set_date))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, statement_of_means)
    json_defendant_response
  end

  def self.json_part_admission_instalments
    json_defendant_response = JsonElements.add_json_element({}.to_json, amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_intention(:instalments))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, statement_of_means)
    json_defendant_response
  end

  def self.json_reject_dispute_full_amount
    json_defendant_response = JsonElements.add_json_element({}.to_json, defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, defence_type(:dispute))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, response_type(:full_defence))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, payment_declaration)
    json_defendant_response
  end

  def self.amount
    {
      "amount": 100
    }.to_json
  end

  def self.defence
    {
      "defence": "test_ Why do you disagree with the claim?"
    }.to_json
  end

  def self.defendant
    {
      "defendant": {
        "name": "Mr Api Defendant",
        "type": "individual",
        "address": {
          "city": "Testford",
          "line1": "2 Test Rd",
          "postcode": "XX1 1XX"
        },
        "dateOfBirth": "2000-01-01"
      }
    }.to_json
  end

  def self.evidence
    {
      "evidence": {}
    }.to_json
  end

  def self.timeline
    {
      "timeline": {}
    }.to_json
  end

  def self.defence_type(key)
    value = {
      dispute: 'DISPUTE',
      states_paid: 'ALREADY_PAID'
    }[key]

    {
      "defenceType": value
    }.to_json
  end

  def self.response_type(key)
    value = {
      full_admission: 'FULL_ADMISSION',
      part_admission: 'PART_ADMISSION',
      full_defence: 'FULL_DEFENCE'
    }[key]

    {
      "responseType": value
    }.to_json
  end

  def self.free_mediation
    {
      "freeMediation": "no"
    }.to_json
  end

  def self.payment_intention(key)
    value = {
      immediately: {date: (DateTime.now + 5).strftime('%Y-%m-%d'), option: 'IMMEDIATELY'},
      by_set_date: {date: (DateTime.now + 30).strftime('%Y-%m-%d'), option: 'BY_SPECIFIED_DATE'},
      instalments: {date: (DateTime.now + 30).strftime('%Y-%m-%d'), option: 'INSTALMENTS'}
    }[key]

    {
      "paymentIntention": {
        "paymentOption": value[:option]
      }.merge(key == :instalments ? repayment_plan(value[:date]) : payment_date(value[:date]))
    }.to_json
  end

  def self.payment_date(date)
    {
      "paymentDate": date
    }
  end

  def self.repayment_plan(date)
    {
      "repaymentPlan": {
        "paymentSchedule": "EACH_WEEK",
        "firstPaymentDate": date,
        "instalmentAmount": 1
      }
    }
  end

  def self.statement_of_means
    {
      "statementOfMeans": {
        "reason": "test_ Briefly explain why you can’t pay immediately",
        "incomes": [{
                      "type": "PENSION",
                      "amount": 100,
                      "frequency": "WEEK"
                    }],
        "expenses": [{
                       "type": "RENT",
                       "amount": 25,
                       "frequency": "WEEK"
                     }],
        "residence": {
          "type": "PRIVATE_RENTAL"
        },
        "employment": {
          "unemployment": {
            "retired": true
          }
        },
        "bankAccounts": [{
                           "type": "CURRENT_ACCOUNT",
                           "joint": false,
                           "balance": 100
                         }]
      }
    }.to_json
  end

  def self.payment_declaration
    {
      "paymentDeclaration": {
        "paidDate": "2000-01-01",
        "explanation": "test_How did you pay this amount?"
      }
    }.to_json
  end

end
