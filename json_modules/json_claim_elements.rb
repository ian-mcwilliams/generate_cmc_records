module JsonClaimElements

  def self.amount
    {
      "amount": {
        "type": "breakdown",
        "rows": [{
                   "reason": "Bakery Cost",
                   "amount": 5000.00
                 }, {}, {}, {}]
      }
    }.to_json
  end

  def self.payment
    {
      "payment": {
        "reference": "RC-1527-6071-6551-7835",
        "amount": 25,
        "status": "Success"
      }
    }.to_json
  end

  def self.interest
    {
      "interest": {
        "rate": 8,
        "type": "standard",
        "interestDate": {
          "type": "submission",
          "endDateType": "submission"
        }
      }
    }.to_json
  end

  def self.claimants
    {
      "claimants": [{
                      "type": "individual",
                      "name": "Mr Api Claimant",
                      "address": {
                        "line1": "1 Test St",
                        "line2": "",
                        "line3": "",
                        "city": "Teston",
                        "postcode": "AA1 1AA"
                      },
                      "mobilePhone": "",
                      "dateOfBirth": "2000-01-01"
                    }]
    }.to_json
  end

  def self.defendants
    {
      "defendants": [{
                       "type": "individual",
                       "name": "Mr Api Defendant",
                       "address": {
                         "line1": "2 Test Rd",
                         "line2": "",
                         "line3": "",
                         "city": "Testford",
                         "postcode": "XX1 1XX"
                       },
                       "email": "civilmoneyclaims+mrdefendant@gmail.com"
                     }]
    }.to_json
  end

  def self.reason
    {
      "reason": "Api test reason"
    }.to_json
  end

  def self.timeline
    {
      "timeline": {
        "rows": [{
                   "date": "1 Jan 2000",
                   "description": "Api test timeline first row"
                 }, {
                   "date": "2 Jan 2000",
                   "description": "Api test timeline second row"
                 }]
      }
    }.to_json
  end

  def self.evidence
    {
      "evidence": {
        "rows": []
      }
    }.to_json
  end

  def self.fee_amount_in_pennies
    {
      "feeAmountInPennies": 2500
    }.to_json
  end

end