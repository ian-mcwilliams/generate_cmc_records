require 'uri'
require 'net/http'
require 'jwt'
require_relative 'json_modules/json_claim'

module GenerateCmcRecords
	include JsonClaim

	def self.generate(args)
		env_prefix = args[:env_prefix]

		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

		# defendant_response = args[:defendant_response]
		# claimant_response = args[:claimant_response]

    # claimant_response_url = "/responses/#{external_id}/claimant/#{claimant_id}"

    claim_api_call_response = claim_api_call(args[:claim], env_prefix, claimant_id, claimant_session_id)

		claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']
    link_defendant_api_call(env_prefix, claim_no, defendant_id)

    external_id = JSON.parse(claim_api_call_response.body)['externalId']
    defendant_response_api_call(external_id, defendant_id, defendant_session_id)
  end

  def self.claim_api_call(claim, env_prefix, claimant_id, claimant_session_id)
    json_claim = JsonClaim.build_json_claim(claim)
    claim_url = "http://#{env_prefix}/claims/#{claimant_id}"
    response = api_call('claim', claim_url, {session_id: claimant_session_id, body: json_claim})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.link_defendant_api_call(env_prefix, claim_no, defendant_id)
    link_defendant_url = "http://#{env_prefix}/testing-support/claims/#{claim_no}/defendant/#{defendant_id}"
    response = api_call('link_defendant', link_defendant_url)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.defendant_response_api_call(defendant_response, external_id, defendant_id, defendant_session_id)
    json_defendant_response = JsonDefendantResponse.build_json_defendant_response(defendant_response)
    defendant_response_url = "/responses/claim/#{external_id}/defendant/#{defendant_id}"
    args = {session_id: defendant_session_id, body: json_defendant_response}
    response = api_call('defendant_response', defendant_response_url, args)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

	def self.session_id_to_user_id(session_id)
		decoded_token = JWT.decode session_id, nil, false
		decoded_token[0]['id']
	end

	def self.api_call(type, url, args={})
		uri = URI(url)
		req = send_request(request_type(type), uri, headers(type, args))
		req.body = args[:body] if args[:body]
		response = nil
		Net::HTTP.start(uri.hostname, uri.port) do |http|
			puts %(sending "#{type}" http request...)
			response = http.request(req)
			puts "response type: #{response.class}"
    end
    response
  end

  def self.send_request(type, uri, headers)
    case type
    when :post
      Net::HTTP::Post.new(uri, headers)
    when :put
      Net::HTTP::Put.new(uri, headers)
    end
  end

	def self.headers(type, args={})
		case type
    when 'claim'
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{args[:session_id]}"
      }
    when 'link_defendant'
      {
        'Content-Type' => 'application/json'
      }
		end
  end

  def self.request_type(type)
    {
        claim: :post,
        link_defendant: :put,
        defendant_response: :post
    }[type.to_sym]
  end

end
