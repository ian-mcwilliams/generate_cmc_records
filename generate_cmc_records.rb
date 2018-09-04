require 'uri'
require 'net/http'
require 'jwt'
require 'date'
require_relative 'json_modules/json_claim'
require_relative 'json_modules/json_defendant_response'

module GenerateCmcRecords
	include JsonClaim
  include JsonDefendantResponse

	def self.generate(args)
    out_file = nil
    if args[:create_result_file]
      Dir.mkdir('results') unless File.exists?('results')
      prefix = DateTime.now.strftime('%y%m%d_%H%M%S_')
      out_file = File.new("results/#{prefix}_out.log", "w")
    end

		env_prefix = args[:env_prefix]

		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

		# defendant_response = args[:defendant_response]
		# claimant_response = args[:claimant_response]

    # claimant_response_url = "/responses/#{external_id}/claimant/#{claimant_id}"

    claim_api_call_response = claim_api_call(args[:claim], env_prefix, claimant_id, claimant_session_id)
    claim_api_call_message = "#{claim_api_call_response.body}\n\n"
    puts claim_api_call_message
    out_file.write(claim_api_call_message) if args[:create_result_file]

		claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']
    set_admissions_to_true(claim_no, args[:path_to_integration_tests])
    admissions_message = "admissions set to TRUE for claim_no '#{claim_no}'\n\n"
    puts admissions_message
    out_file.write(admissions_message) if args[:create_result_file]

    link_defendant_api_call(env_prefix, claim_no, defendant_id)
    link_defendant_message = "defendant_id set to '#{defendant_id}' for claim_no '#{claim_no}'\n\n"
    puts link_defendant_message
    out_file.write(link_defendant_message) if args[:create_result_file]

    external_id = JSON.parse(claim_api_call_response.body)['externalId']
    defendant_api_call_response = defendant_response_api_call(args[:defendant_response], env_prefix, external_id, defendant_id, defendant_session_id)
    defendant_api_call_message = "#{defendant_api_call_response.body}\n\n"
    puts defendant_api_call_message
    out_file.write(defendant_api_call_message) if args[:create_result_file]
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
