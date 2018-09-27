require 'jwt'
require_relative 'api_call'
require_relative '../json_modules/json_response_body'
require_relative 'logging'

module GenerateCmcRecords
	include JsonResponseBody
  include Logging

	def self.generate(args)
    iteration_id = args[:iteration_id]
		target_env = args[:target_env]
    run_action = args[:run_action]
		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

    Logging.output_message("###   ITERATION #{iteration_id}   ###\n\n") if iteration_id

    claim_api_call_response = ApiCall.claim_api_call(target_env, args[:claim], claimant_id, claimant_session_id)
    claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']

    if target_env == :local
      set_admissions_to_true(claim_no, args[:path_to_integration_tests])
      Logging.output_message("admissions set to TRUE for claim_no '#{claim_no}'\n\n")
    end

    if run_action[:link_defendant]
      ApiCall.link_defendant_api_call(target_env, claim_no, defendant_id)
      Logging.output_message("defendant_id set to '#{defendant_id}' for claim_no '#{claim_no}'\n\n")

      if run_action[:defendant_response]
        external_id = JSON.parse(claim_api_call_response.body)['externalId']
        ApiCall.defendant_response_api_call(target_env, args[:defendant_response], external_id, defendant_id, defendant_session_id)

        if run_action[:claimant_response]
          ApiCall.claimant_response_api_call(target_env, run_action[:claimant_response], external_id, claimant_id, claimant_session_id)
        end
      end
    end
  end

  def self.set_admissions_to_true(claim_no, rel_dir)
    bash_command = "docker-compose exec shared-database psql -U claimstore -c \"update claim set features = '[\\\"admissions\\\"]'::JSONB where reference_number = '#{claim_no}'\""
    Dir.chdir(rel_dir) { system(bash_command) }
  end

	def self.session_id_to_user_id(session_id)
		decoded_token = JWT.decode session_id, nil, false
		decoded_token[0]['id']
	end

end
