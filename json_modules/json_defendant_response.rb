require_relative 'json_elements'

module JsonDefendantResponse
  include JsonElements

  def self.build_json_defendant_response(defendant_response)
    {
        "defendant": {
            "name": "Mr Api Defendant",
            "type": "individual",
            "address": {
                "city": "Testford",
                "line1": "2 Test Rd",
                "postcode": "XX1 1XX"
            },
            "dateOfBirth": "2000-01-01",
            "mobilePhone": "01234567890"
        },
        "responseType": "FULL_ADMISSION",
        "paymentIntention": {
            "paymentDate": "2018-09-04",
            "paymentOption": "IMMEDIATELY"
        }
    }.to_json
  end

end
