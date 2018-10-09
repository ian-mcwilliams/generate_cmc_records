require 'uri'
require 'net/http'

module ApiCall

  def self.env_url(target_env)
    {
      'local' => 'localhost:4400',
      'aat' => 'cmc-claim-store-aat.service.core-compute-aat.internal',
      'demo' => 'cmc-claim-store-demo.service.core-compute-demo.internal'
    }[target_env]
  end

  def self.response_url(target_env, journey, args)
    {
      claim: "#{env_url(target_env)}/claims/#{args[:claimant_id]}",
      link_defendant: "#{env_url(target_env)}/testing-support/claims/#{args[:claim_no]}/defendant/#{args[:defendant_id]}",
      defendant_response: "#{env_url(target_env)}/responses/claim/#{args[:external_id]}/defendant/#{args[:defendant_id]}",
      claimant_response: "http://#{env_url(target_env)}/responses/#{args[:external_id]}/claimant/#{args[:claimant_id]}"
    }[journey]
  end

  def self.journey_api_call(target_env, journey, args)
    json_blob = nil
    if %i[claim defendant_response claimant_response].include?(journey)
      json_blob = JsonResponseBody.json_response_body(journey, args[:journey_data])
    end
    api_url = response_url(target_env, journey, args)
    api_call(target_env, journey, api_url, json_blob, args)
  end

  def self.api_call(target_env, journey, url, body, args={})
    uri = journey == :claimant_response ? URI(url) : URI("http://#{url}")
    req = build_request(journey, uri, args[:session_id])
    req.body = body if body
    response = env_api_call(target_env, journey, uri, req)
    if journey == :claimant_response
      raise('api call failure') unless response.class == Net::HTTPCreated
    else
      raise('api call failure') unless response.class == Net::HTTPOK
    end
    response
  end

  def self.env_api_call(target_env, journey, uri, req)
    response = nil
    case target_env.to_sym
    when :aat
      Net::HTTP.new(env_url(target_env), nil, 'proxyout.reform.hmcts.net', 8080).start do |http|
        response = send_request(http, req, journey)
      end
    when :local, :demo
      Net::HTTP.start(uri.hostname, uri.port) do |http|
        response = send_request(http, req, journey)
      end
    end
    response
  end

  def self.send_request(http, req, journey)
    Logging.output_message(%(sending "#{journey}" http request as: #{req.uri}))
    Logging.output_message("request body: #{req.body}")
    response = http.request(req)
    Logging.output_message("response type: #{response.class}")
    Logging.output_message("response body: #{response.body}\n\n")
    response
  end

  def self.build_request(journey, uri, session_id=nil)
    http_module = { post: Net::HTTP::Post, put: Net::HTTP::Put }[request_type(journey)]
    http_module.new(uri, headers(journey, session_id))
  end

  def self.headers(journey, session_id=nil)
    headers_hash = { 'Content-Type' => 'application/json' }
    if %i[claim defendant_response claimant_response].include?(journey)
      headers_hash['Authorization'] = "Bearer #{session_id}"
    end
    headers_hash
  end

  def self.request_type(journey)
    {
      claim: :post,
      link_defendant: :put,
      defendant_response: :post,
      claimant_response: :post
    }[journey.to_sym]
  end

end