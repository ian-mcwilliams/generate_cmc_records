require 'uri'
require 'net/http'
require 'jwt'
require_relative 'json_claim'

module GenerateCmcRecords
	include JsonClaim

	def self.generate(args)
		env_prefix = args[:env_prefix]

		claimant_session_id = args[:claimant_session_id]
		# defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_claimant_id(claimant_session_id)

		json_claim = JsonClaim.build_json_claim(args[:claim])
		# defendant_response = args[:defendant_response]
		# claimant_response = args[:claimant_response]

		claim_url = "http://#{env_prefix}/claims/#{claimant_id}"

		api_call('claim', claim_url, args[:claimant_session_id], json_claim)
	end

	def self.session_id_to_claimant_id(claimant_session_id)
		decoded_token = JWT.decode claimant_session_id, nil, false
		decoded_token[0]['id']
	end

	def self.api_call(type, url, session_id, body)
		uri = URI(url)
		headers = {
			'Content-Type' => 'application/json',
			'Authorization' => "Bearer #{session_id}"
		}
		req = Net::HTTP::Post.new(uri, headers)
		req.body = body
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
			puts %(sending "#{type}" http request...)
			response = http.request(req)
			puts "response type: #{response.class}"
		end
	end

end

session_id = 'eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJkcjBidG5lcnY4Mm1ob2VkMHRwb2FxbXR0cCIsInN1YiI6IjI3IiwiaWF0IjoxNTM1NzExOTUwLCJleHAiOjE1MzU3NDA3NTAsImRhdGEiOiJjaXRpemVuLGNsYWltYW50LGNpdGl6ZW4tbG9hMSxjbGFpbWFudC1sb2ExIiwidHlwZSI6IkFDQ0VTUyIsImlkIjoiMjciLCJmb3JlbmFtZSI6IkNsYWltIiwic3VybmFtZSI6IkFudCIsImRlZmF1bHQtc2VydmljZSI6ImNtYyIsImxvYSI6MSwiZGVmYXVsdC11cmwiOiJodHRwczovL3d3dy1jaXRpemVuLm1vbmV5Y2xhaW0ucmVmb3JtLmhtY3RzLm5ldDozMDAwL2NtYyIsImdyb3VwIjoiY2l0aXplbnMifQ.PqhMHH0q9SwaNLmmX8xGCK7Nz381R37MHc_-h8oWdn4'

args = {
	env_prefix: 'localhost:4400',
	claimant_session_id: session_id,
}

GenerateCmcRecords.generate(args)







