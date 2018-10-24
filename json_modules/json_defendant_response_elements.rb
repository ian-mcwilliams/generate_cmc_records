require 'date'

module JsonDefendantResponseElements

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
    current_amount = JSON.parse(amount)['amount']
    rounded_amount = current_amount.is_a?(Integer) ? current_amount : current_amount.round.to_i + 1
    end_date = (DateTime.parse(date) + rounded_amount).strftime('%Y-%m-%d')
    {
      "repaymentPlan": {
        "paymentSchedule": "EACH_WEEK",
        "firstPaymentDate": date,
        "instalmentAmount": 1,
        "paymentLength": "#{rounded_amount} weeks",
        "completionDate": end_date
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
                         }],
        "carer": false,
        "disability": "NO",
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