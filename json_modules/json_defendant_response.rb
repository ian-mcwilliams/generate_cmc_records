require 'date'
require_relative 'json_elements'
require_relative 'json_defendant_response_elements'

module JsonDefendantResponse
  include JsonElements
  include JsonDefendantResponseElements

  def self.build_json_defendant_response(defendant_response)
    case defendant_response
    when :full_admission_immediate
      json_full_admission_immediate
    when :full_admission_by_set_date
      json_full_admission_by_set_date
    when :full_admission_instalments
      json_full_admission_instalments
    when :states_paid, :reject_paid_what_i_believe_i_owe_full
      json_states_paid
    when :part_admission_immediately
      json_part_admission_immediately
    when :part_admission_by_set_date
      json_part_admission_by_set_date
    when :part_admission_instalments
      json_part_admission_instalments
    when :part_admission_states_paid, :reject_paid_what_i_believe_i_owe_part
      json_part_admission_states_paid
    when :reject_dispute_full_amount
      json_reject_dispute_full_amount
    end
  end

  def self.json_full_admission_immediate
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:immediately))
    json_defendant_response
  end

  def self.json_full_admission_by_set_date
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:by_set_date))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.statement_of_means)
    json_defendant_response
  end

  def self.json_full_admission_instalments
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:full_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:instalments))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.statement_of_means)
    json_defendant_response
  end

  def self.json_states_paid
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence_type(:states_paid))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:full_defence))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_declaration)
    json_defendant_response
  end

  def self.json_part_admission_immediately
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:immediately))
    json_defendant_response
  end

  def self.json_part_admission_by_set_date
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:by_set_date))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.statement_of_means)
    json_defendant_response
  end

  def self.json_part_admission_instalments
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_intention(:instalments))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.statement_of_means)
    json_defendant_response
  end

  def self.json_part_admission_states_paid
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.amount)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:part_admission))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.free_mediation)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_declaration)
    json_defendant_response
  end

  def self.json_reject_dispute_full_amount
    json_defendant_response = JsonElements.add_json_element({}.to_json, JsonDefendantResponseElements.defence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.evidence)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.timeline)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defendant)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.defence_type(:dispute))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.response_type(:full_defence))
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.payment_declaration)
    json_defendant_response = JsonElements.add_json_element(json_defendant_response, JsonDefendantResponseElements.free_mediation)
    json_defendant_response
  end

end
