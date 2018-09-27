require 'uri'
require 'net/http'
require 'jwt'
require_relative 'json_modules/json_claim'
require_relative 'json_modules/json_defendant_response'
require_relative 'json_modules/json_claimant_response'

module GenerateCmcRecords
	include JsonClaim
  include JsonDefendantResponse
  include JsonClaimantResponse

  def self.out_file(out_file = nil)
    $out_file = out_file if out_file
    $out_file
  end

  def self.env_url(target_env)
    {
      'local' => 'localhost:4400',
      'aat' => 'cmc-claim-store-aat.service.core-compute-aat.internal',
      'demo' => 'cmc-claim-store-demo.service.core-compute-demo.internal'
    }[target_env]
  end

	def self.generate(args)
    iteration_id = args[:iteration_id]
		target_env = args[:target_env]
    env_prefix = env_url(target_env)
    out_file(args[:out_file])
    run_action = args[:run_action]
		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

    output_message("###   ITERATION #{iteration_id}   ###\n\n") if iteration_id

    claim_api_call_response = claim_api_call(target_env, args[:claim], env_prefix, claimant_id, claimant_session_id)
    claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']

    if target_env == :local
      set_admissions_to_true(claim_no, args[:path_to_integration_tests])
      output_message("admissions set to TRUE for claim_no '#{claim_no}'\n\n")
    end

    if run_action[:link_defendant]
      link_defendant_api_call(target_env, env_prefix, claim_no, defendant_id)
      output_message("defendant_id set to '#{defendant_id}' for claim_no '#{claim_no}'\n\n")

      if run_action[:defendant_response]
        external_id = JSON.parse(claim_api_call_response.body)['externalId']
        defendant_response_api_call(target_env, args[:defendant_response], env_prefix, external_id, defendant_id, defendant_session_id)

        if run_action[:claimant_response]
          claimant_response_api_call(target_env, run_action[:claimant_response], env_prefix, external_id, claimant_id, claimant_session_id)
        end
      end
    end
  end

  def self.output_message(message)
    puts message
    file = out_file
    file.write(message) if file
  end

  def self.claim_api_call(target_env, claim, env_prefix, claimant_id, claimant_session_id)
    json_claim = JsonClaim.build_json_claim(claim)
    claim_url = "#{env_prefix}/claims/#{claimant_id}"
    response = api_call(target_env, 'claim', claim_url, {session_id: claimant_session_id, body: json_claim, env_prefix: env_prefix})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.set_admissions_to_true(claim_no, rel_dir)
    bash_command = "docker-compose exec shared-database psql -U claimstore -c \"update claim set features = '[\\\"admissions\\\"]'::JSONB where reference_number = '#{claim_no}'\""
    Dir.chdir(rel_dir) { system(bash_command) }
  end

  def self.link_defendant_api_call(target_env, env_prefix, claim_no, defendant_id)
    link_defendant_url = "#{env_prefix}/testing-support/claims/#{claim_no}/defendant/#{defendant_id}"
    response = api_call(target_env, 'link_defendant', link_defendant_url, {env_prefix: env_prefix})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.defendant_response_api_call(target_env, defendant_response, env_prefix, external_id, defendant_id, defendant_session_id)
    json_defendant_response = JsonDefendantResponse.build_json_defendant_response(defendant_response)
    defendant_response_url = "#{env_prefix}/responses/claim/#{external_id}/defendant/#{defendant_id}"
    args = {session_id: defendant_session_id, body: json_defendant_response, env_prefix: env_prefix}
    response = api_call(target_env, 'defendant_response', defendant_response_url, args)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.claimant_response_api_call(target_env, claimant_response, env_prefix, external_id, claimant_id, claimant_session_id)
    json_claimant_response = JsonClaimantResponse.build_json_claimant_response(claimant_response)
    claimant_response_url = "http://#{env_prefix}/responses/#{external_id}/claimant/#{claimant_id}"
    args = {session_id: claimant_session_id, body: json_claimant_response, env_prefix: env_prefix}
    response = api_call(target_env, 'claimant_response', claimant_response_url, args)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

	def self.session_id_to_user_id(session_id)
		decoded_token = JWT.decode session_id, nil, false
		decoded_token[0]['id']
	end

	def self.api_call(target_env, type, url, args={})
    uri = URI("http://#{url}")
    req = build_request(request_type(type), uri, headers(type, args))
    req.body = args[:body] if args[:body]
    response = nil
    case target_env.to_sym
    when :aat
      Net::HTTP.new(args[:env_prefix], nil, 'proxyout.reform.hmcts.net', 8080).start do |http|
        response = api_request(http, req, type)
      end
    when :local, :demo
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        response = api_request(http, req, type)
      end
    end
    response
  end

  def self.api_request(http, req, type)
    output_message(%(sending "#{type}" http request as: #{req.uri}))
    output_message("request body: #{req.body}")
    response = http.request(req)
    output_message("response type: #{response.class}")
    output_message("response body: #{response.body}\n\n")
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
