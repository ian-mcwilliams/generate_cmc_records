require 'uri'
require 'net/http'
require 'jwt'
require_relative 'json_modules/json_claim'
require_relative 'json_modules/json_defendant_response'

module GenerateCmcRecords
	include JsonClaim
  include JsonDefendantResponse

	def self.generate(args)
    iteration_id = args[:iteration_id]
		env_prefix = args[:env_prefix]
    out_file = args[:out_file]
    run_action = args[:run_action]
		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

    output_message(out_file, "###   ITERATION #{iteration_id}   ###\n\n") if iteration_id

    claim_api_call_response = claim_api_call(args[:claim], env_prefix, claimant_id, claimant_session_id)
    output_message(out_file, "#{claim_api_call_response.body}\n\n", )

    if args[:env_prefix]['localhost']
      claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']
      set_admissions_to_true(claim_no, args[:path_to_integration_tests])
      output_message(out_file, "admissions set to TRUE for claim_no '#{claim_no}'\n\n")
    end

    if run_action[:link_defendant]
      link_defendant_api_call(env_prefix, claim_no, defendant_id)
      output_message(out_file, "defendant_id set to '#{defendant_id}' for claim_no '#{claim_no}'\n\n")

      if run_action[:defendant_response]
        external_id = JSON.parse(claim_api_call_response.body)['externalId']
        defendant_api_call_response = defendant_response_api_call(args[:defendant_response], env_prefix, external_id, defendant_id, defendant_session_id)
        output_message(out_file, "#{defendant_api_call_response.body}\n\n")
      end
    end
  end

  def self.output_message(out_file, message)
    puts message
    out_file.write(message) if out_file
  end

  def self.claim_api_call(claim, env_prefix, claimant_id, claimant_session_id)
    json_claim = JsonClaim.build_json_claim(claim)
    claim_url = "http://#{env_prefix}/claims/#{claimant_id}"
    response = api_call('claim', claim_url, {session_id: claimant_session_id, body: json_claim})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.set_admissions_to_true(claim_no, rel_dir)
    bash_command = "docker-compose exec shared-database psql -U claimstore -c \"update claim set features = '[\\\"admissions\\\"]'::JSONB where reference_number = '#{claim_no}'\""
    Dir.chdir(rel_dir) { system(bash_command) }
  end

  def self.link_defendant_api_call(env_prefix, claim_no, defendant_id)
    link_defendant_url = "http://#{env_prefix}/testing-support/claims/#{claim_no}/defendant/#{defendant_id}"
    response = api_call('link_defendant', link_defendant_url)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.defendant_response_api_call(defendant_response, env_prefix, external_id, defendant_id, defendant_session_id)
    json_defendant_response = JsonDefendantResponse.build_json_defendant_response(defendant_response)
    defendant_response_url = "http://#{env_prefix}/responses/claim/#{external_id}/defendant/#{defendant_id}"
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
		req = build_request(request_type(type), uri, headers(type, args))
		req.body = args[:body] if args[:body]
		response = nil
		Net::HTTP.start(uri.hostname, uri.port) do |http|
			puts %(sending "#{type}" http request...)
			response = http.request(req)
			puts "response type: #{response.class}"
    end
    response
  end

  def self.build_request(type, uri, headers)
    case type
    when :post
      Net::HTTP::Post.new(uri, headers)
    when :put
      Net::HTTP::Put.new(uri, headers)
    end
  end

	def self.headers(type, args={})
		case type
    when 'claim', 'defendant_response', 'claimant_response'
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
        defendant_response: :post,
        claimant_response: :post
    }[type.to_sym]
  end

end
