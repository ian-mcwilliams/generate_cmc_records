# Generate CMC Records

## Purpose

Chain api links to automatically generate journeys up to given state

##Scope

Local, demo and aat. Anything from individual claim to sets of claims linked to defendants with responses and claimant responses as specified for the run

## How to run

### Set value in config.json

#### target_env
"local", "aat" or "demo"

#### path_to_integration_tests 
- if local, set relative path to cmc-integration-tests to ensure feature admissions set for this claim (it is a workaround because my local setup wasn't letting me switch the toggle)
- if demo or aat this setting will be ignored

#### claimant_session_id
from logged in browser session

#### defendant_session_id
from logged in browser session

#### create_result_file
boolean - if true will save the console output to timestamped file in /results

### Add run specification in run_spec.rb

The ruby hash (for a single run) or array (for a set of single runs) must be returned from the run_spec method in the RunSpec module, beyond this it can be coded in any way preferred

#### Individual run hash

For an unlinked claim alone, just specify false for link_defendant:

```ruby
{ link_defendant: false }
```

For a claim linked to the defendant account where no defendant response has been processed, specify true for link _defendant

```ruby
{ link_defendant: false }
```

For a claim linked to a defendant account where a defendant response has been submitted, specify true for link_defendant and enter a defendant_response key value pair:

```ruby
{
  link_defendant: false,
  defendant_response: :full_admission_by_set_date
}
```

NB If link_defendant is specified as false then any other key value pairs will be ignored.

To additionally submit a claimant_response add the relevant value to an additional :claimant_response key

```ruby
{
  link_defendant: false,
  defendant_response: :full_admission_by_set_date,
  claimant_response: :accept_repayment_ccj
}
```

### Valid defendant response symbols

```ruby
  :full_admission_immediate
  :full_admission_by_set_date
  :full_admission_instalments
  :reject_paid_what_i_believe_i_owe_full
  :part_admission_immediately
  :part_admission_by_set_date
  :part_admission_instalments
  :reject_paid_what_i_believe_i_owe_part
  :reject_dispute_full_amount
```

### Valid claimant response symbols

Work in progress - to be added
