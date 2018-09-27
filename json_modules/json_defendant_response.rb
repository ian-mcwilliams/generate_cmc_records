require 'date'
require_relative 'json_defendant_response_elements'

module JsonDefendantResponse
  include JsonDefendantResponseElements

  def self.build_json_blob(defendant_response)
    case defendant_response
    when :full_admission_immediate
      json_full_admission_immediate
    when :full_admission_by_set_date
      json_full_admission_by_set_date
    when :full_admission_instalments
      json_full_admission_instalments
    when :reject_paid_what_i_believe_i_owe_full
      json_reject_paid_what_i_believe_i_owe_full
    when :part_admission_immediately
      json_part_admission_immediately
    when :part_admission_by_set_date
      json_part_admission_by_set_date
    when :part_admission_instalments
      json_part_admission_instalments
    when :reject_paid_what_i_believe_i_owe_part
      json_reject_paid_what_i_believe_i_owe_part
    when :reject_dispute_full_amount
      json_reject_dispute_full_amount
    end
  end

  def self.json_full_admission_immediate
    [
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:full_admission),
      JsonDefendantResponseElements.payment_intention(:immediately)
    ]
  end

  def self.json_full_admission_by_set_date
    [
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:full_admission),
      JsonDefendantResponseElements.payment_intention(:by_set_date),
      JsonDefendantResponseElements.statement_of_means
    ]
  end

  def self.json_full_admission_instalments
    [
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:full_admission),
      JsonDefendantResponseElements.payment_intention(:instalments),
      JsonDefendantResponseElements.statement_of_means
    ]
  end

  def self.json_reject_paid_what_i_believe_i_owe_full
    [
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.defence_type(:states_paid),
      JsonDefendantResponseElements.response_type(:full_defence),
      JsonDefendantResponseElements.payment_declaration
    ]
  end

  def self.json_part_admission_immediately
    [
      JsonDefendantResponseElements.amount,
      JsonDefendantResponseElements.defence,
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:part_admission),
      JsonDefendantResponseElements.free_mediation,
      JsonDefendantResponseElements.payment_intention(:immediately)
    ]
  end

  def self.json_part_admission_by_set_date
    [
      JsonDefendantResponseElements.amount,
      JsonDefendantResponseElements.defence,
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:part_admission),
      JsonDefendantResponseElements.free_mediation,
      JsonDefendantResponseElements.payment_intention(:by_set_date),
      JsonDefendantResponseElements.statement_of_means
    ]
  end

  def self.json_part_admission_instalments
    [
      JsonDefendantResponseElements.amount,
      JsonDefendantResponseElements.defence,
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:part_admission),
      JsonDefendantResponseElements.free_mediation,
      JsonDefendantResponseElements.payment_intention(:instalments),
      JsonDefendantResponseElements.statement_of_means
    ]
  end

  def self.json_reject_paid_what_i_believe_i_owe_part
    [
      JsonDefendantResponseElements.amount,
      JsonDefendantResponseElements.defence,
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.response_type(:part_admission),
      JsonDefendantResponseElements.free_mediation,
      JsonDefendantResponseElements.payment_declaration
    ]
  end

  def self.json_reject_dispute_full_amount
    [
      JsonDefendantResponseElements.defence,
      JsonDefendantResponseElements.evidence,
      JsonDefendantResponseElements.timeline,
      JsonDefendantResponseElements.defendant,
      JsonDefendantResponseElements.defence_type(:dispute),
      JsonDefendantResponseElements.response_type(:full_defence),
      JsonDefendantResponseElements.payment_declaration,
      JsonDefendantResponseElements.free_mediation
    ]
  end

end
