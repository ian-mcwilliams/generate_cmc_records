require 'uri'
require 'net/http'

module ApiCall

  def self.claim_api_call(target_env, claim, env_prefix, claimant_id, claimant_session_id)
    json_claim = JsonResponseBody.json_response_body(:claim, claim)
    claim_url = "#{env_prefix}/claims/#{claimant_id}"
    response = api_call(target_env, 'claim', claim_url, {session_id: claimant_session_id, body: json_claim, env_prefix: env_prefix})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.link_defendant_api_call(target_env, env_prefix, claim_no, defendant_id)
    link_defendant_url = "#{env_prefix}/testing-support/claims/#{claim_no}/defendant/#{defendant_id}"
    response = api_call(target_env, 'link_defendant', link_defendant_url, {env_prefix: env_prefix})
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.defendant_response_api_call(target_env, defendant_response, env_prefix, external_id, defendant_id, defendant_session_id)
    json_defendant_response = JsonResponseBody.json_response_body(:defendant_response, defendant_response)
    defendant_response_url = "#{env_prefix}/responses/claim/#{external_id}/defendant/#{defendant_id}"
    args = {session_id: defendant_session_id, body: json_defendant_response, env_prefix: env_prefix}
    response = api_call(target_env, 'defendant_response', defendant_response_url, args)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
  end

  def self.claimant_response_api_call(target_env, claimant_response, env_prefix, external_id, claimant_id, claimant_session_id)
    json_claimant_response = JsonResponseBody.json_response_body(:claimant_response, claimant_response)
    claimant_response_url = "http://#{env_prefix}/responses/#{external_id}/claimant/#{claimant_id}"
    args = {session_id: claimant_session_id, body: json_claimant_response, env_prefix: env_prefix}
    response = api_call(target_env, 'claimant_response', claimant_response_url, args)
    raise('api call failure') unless response.class == Net::HTTPOK
    response
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
    Logging.output_message(%(sending "#{type}" http request as: #{req.uri}))
    Logging.output_message("request body: #{req.body}")
    response = http.request(req)
    Logging.output_message("response type: #{response.class}")
    Logging.output_message("response body: #{response.body}\n\n")
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