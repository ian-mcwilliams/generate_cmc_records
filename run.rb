require 'date'
require_relative 'generate_cmc_records'

##################################
###   ENTER CONFIG DATA HERE   ###
##################################

# For environment prefix refer to section 3 (API access) here: https://tools.hmcts.net/confluence/display/ROC/Environment+Links
# env_prefix = 'cmc-claim-store-aat.service.core-compute-aat.internal'
env_prefix = 'localhost:4400'

# the relative path from the base directory of this project to cmc-integration-tests
path_to_integration_tests = '../../../hmcts/cmc-integration-tests'

# session_id token from logged in claimant/defendant
claimant_session_id = 'eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiI2c2I5czlodWtvZG1jamp1bnBtZG84NHR1YiIsInN1YiI6IjI3IiwiaWF0IjoxNTM2NTY2NTA5LCJleHAiOjE1MzY1OTUzMDksImRhdGEiOiJjaXRpemVuLGNsYWltYW50LGNpdGl6ZW4tbG9hMSxjbGFpbWFudC1sb2ExIiwidHlwZSI6IkFDQ0VTUyIsImlkIjoiMjciLCJmb3JlbmFtZSI6IkNsYWltIiwic3VybmFtZSI6IkFudCIsImRlZmF1bHQtc2VydmljZSI6ImNtYyIsImxvYSI6MSwiZGVmYXVsdC11cmwiOiJodHRwczovL3d3dy1jaXRpemVuLm1vbmV5Y2xhaW0ucmVmb3JtLmhtY3RzLm5ldDozMDAwL2NtYyIsImdyb3VwIjoiY2l0aXplbnMifQ.eVISalW6sl-CwkN-bfiPcahfaLDLUyHupgERyfwmDoY'
defendant_session_id = 'eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIxc3R2bGZxZGg0azQzdWZ1dWNzc29kcTU1aCIsInN1YiI6IjMwIiwiaWF0IjoxNTM2NTY2NTQyLCJleHAiOjE1MzY1OTUzNDIsImRhdGEiOiJjaXRpemVuLGNtYy1wcml2YXRlLWJldGEsbGV0dGVyLWhvbGRlcixsZXR0ZXItaG9sZGVyLGxldHRlci1ob2xkZXIsbGV0dGVyLWhvbGRlcixsZXR0ZXItaG9sZGVyLGxldHRlci1ob2xkZXIsbGV0dGVyLWhvbGRlcixsZXR0ZXItaG9sZGVyLGxldHRlci1ob2xkZXIsbGV0dGVyLWhvbGRlcixsZXR0ZXItaG9sZGVyLGRlZmVuZGFudCxjbGFpbWFudCxsZXR0ZXItMjksbGV0dGVyLTMxLGxldHRlci0zMixsZXR0ZXItMzMsbGV0dGVyLTM0LGxldHRlci0zNSxsZXR0ZXItMzYsbGV0dGVyLTM3LGxldHRlci0zOCxsZXR0ZXItNDAsbGV0dGVyLTM5LGxldHRlci1ob2xkZXIsbGV0dGVyLTQxLGxldHRlci1ob2xkZXIsbGV0dGVyLTQyLGxldHRlci1ob2xkZXIsbGV0dGVyLTQ0LGNpdGl6ZW4tbG9hMSxjbWMtcHJpdmF0ZS1iZXRhLWxvYTEsbGV0dGVyLWhvbGRlci1sb2ExLGxldHRlci1ob2xkZXItbG9hMSxsZXR0ZXItaG9sZGVyLWxvYTEsbGV0dGVyLWhvbGRlci1sb2ExLGxldHRlci1ob2xkZXItbG9hMSxsZXR0ZXItaG9sZGVyLWxvYTEsbGV0dGVyLWhvbGRlci1sb2ExLGxldHRlci1ob2xkZXItbG9hMSxsZXR0ZXItaG9sZGVyLWxvYTEsbGV0dGVyLWhvbGRlci1sb2ExLGxldHRlci1ob2xkZXItbG9hMSxkZWZlbmRhbnQtbG9hMSxjbGFpbWFudC1sb2ExLGxldHRlci0yOS1sb2ExLGxldHRlci0zMS1sb2ExLGxldHRlci0zMi1sb2ExLGxldHRlci0zMy1sb2ExLGxldHRlci0zNC1sb2ExLGxldHRlci0zNS1sb2ExLGxldHRlci0zNi1sb2ExLGxldHRlci0zNy1sb2ExLGxldHRlci0zOC1sb2ExLGxldHRlci00MC1sb2ExLGxldHRlci0zOS1sb2ExLGxldHRlci1ob2xkZXItbG9hMSxsZXR0ZXItNDEtbG9hMSxsZXR0ZXItaG9sZGVyLWxvYTEsbGV0dGVyLTQyLWxvYTEsbGV0dGVyLWhvbGRlci1sb2ExLGxldHRlci00NC1sb2ExIiwidHlwZSI6IkFDQ0VTUyIsImlkIjoiMzAiLCJmb3JlbmFtZSI6IkRlZmVuZCIsInN1cm5hbWUiOiJBbnQiLCJkZWZhdWx0LXNlcnZpY2UiOiJDTUMiLCJsb2EiOjEsImRlZmF1bHQtdXJsIjoiaHR0cHM6Ly93d3ctY2l0aXplbi5tb25leWNsYWltLnJlZm9ybS5obWN0cy5uZXQ6MzAwMC9jbWMiLCJncm91cCI6ImNtYy1wcml2YXRlLWJldGEifQ.CXxHsZ--zARJRPkAnauxIU82xSijh2k6YZFLgRjGS5c'

# if true will create a results dir in this project and save the output from current run to a timestamped log file
create_result_file = false

run_actions = [
  {
    link_defendant: true,
    defendant_response: :full_admission_immediate
  },
  {
    link_defendant: true,
    defendant_response: :full_admission_by_set_date
  }
]

##################################
#   EXECUTION RUNS FROM HERE   ###
##################################

out_file = nil
if create_result_file
  Dir.mkdir('results') unless File.exists?('results')
  prefix = DateTime.now.strftime('%y%m%d_%H%M%S_')
  out_file = File.new("results/#{prefix}_out.log", "w")
end

run_actions.each_with_index do |run_action, i|
  args = {
    iteration_id: i + 1,
    env_prefix: env_prefix,
    claimant_session_id: claimant_session_id,
    defendant_session_id: defendant_session_id,
    defendant_response: run_action[:defendant_response],
    path_to_integration_tests: path_to_integration_tests,
    out_file: out_file,
    run_action: run_action
  }

  GenerateCmcRecords.generate(args)
end
