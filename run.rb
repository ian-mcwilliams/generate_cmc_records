require 'date'
require_relative 'generate_cmc_records'
require_relative 'run_spec'

config_file = File.open('config.json')
config = JSON.parse(config_file.read)

out_file = nil
if config['create_result_file']
  Dir.mkdir('results') unless File.exists?('results')
  prefix = DateTime.now.strftime('%y%m%d_%H%M%S_')
  out_file = File.new("results/#{prefix}_out.log", "w")
end

RunSpec.run_spec.each_with_index do |run_action, i|
  args = {
    iteration_id: i + 1,
    target_env: config['target_env'],
    claimant_session_id: config['claimant_session_id'],
    defendant_session_id: config['defendant_session_id'],
    defendant_response: run_action[:defendant_response],
    path_to_integration_tests: config['path_to_integration_tests'],
    out_file: out_file,
    run_action: run_action
  }

  GenerateCmcRecords.generate(args)
end
