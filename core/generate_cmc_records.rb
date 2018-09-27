require 'date'
require 'jwt'
require_relative 'api_call'
require_relative 'logging'
require_relative '../json_modules/json_response_body'
require_relative '../run_spec'

module GenerateCmcRecords
	include JsonResponseBody
  include Logging

  def self.generate_records
    config_file = File.open('config.json')
    config = JSON.parse(config_file.read)

    create_results_file if config['create_result_file']

    args = {
      claimant_session_id: config['claimant_session_id'],
      defendant_session_id: config['defendant_session_id'],
      path_to_integration_tests: config['path_to_integration_tests']
    }

    RunSpec.run_spec.each_with_index do |run_action, i|
      Logging.output_message("###   ITERATION #{i + 1}   ###\n\n")
      generate_record(config['target_env'], run_action, args)
    end
  end

  def self.generate_record(target_env, run_action, args)
    begin
      generation_actions(target_env, run_action, args)
    rescue => e
      Logging.output_message(e.inspect)
      Logging.output_message(e.backtrace)
    end
  end

	def self.generation_actions(target_env, run_action, args)
		claimant_session_id = args[:claimant_session_id]
    defendant_session_id = args[:defendant_session_id]
		claimant_id = session_id_to_user_id(claimant_session_id)
		defendant_id = session_id_to_user_id(defendant_session_id)

    claim_args = {claimant_id: claimant_id, session_id: claimant_session_id}
    claim_api_call_response = ApiCall.journey_api_call(target_env, :claim, claim_args)
    claim_no = JSON.parse(claim_api_call_response.body)['referenceNumber']

    if target_env == :local
      set_admissions_to_true(claim_no, args[:path_to_integration_tests])
      Logging.output_message("admissions set to TRUE for claim_no '#{claim_no}'\n\n")
    end

    if run_action[:link_defendant]
      link_defendant_args = {claim_no: claim_no, defendant_id: defendant_id}
      ApiCall.journey_api_call(target_env, :link_defendant, link_defendant_args)
      Logging.output_message("defendant_id set to '#{defendant_id}' for claim_no '#{claim_no}'\n\n")

      if run_action[:defendant_response]
        external_id = JSON.parse(claim_api_call_response.body)['externalId']
        defendant_response_args = {
          journey_data: run_action[:defendant_response],
          external_id: external_id,
          defendant_id: defendant_id,
          session_id: defendant_session_id
        }
        ApiCall.journey_api_call(target_env, :defendant_response, defendant_response_args)

        if run_action[:claimant_response]
          claimant_response_args = {
            journey_data: run_action[:claimant_response],
            external_id: external_id,
            claimant_id: claimant_id,
            session_id: claimant_session_id
          }
          ApiCall.journey_api_call(target_env, :claimant_response, claimant_response_args)
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

  def create_results_file
    Dir.mkdir('results') unless File.exists?('results')
    prefix = DateTime.now.strftime('%y%m%d_%H%M%S_')
    Logging.out_file(File.new("results/#{prefix}_out.log", "w"))
  end

end
