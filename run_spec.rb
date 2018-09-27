module RunSpec

  # return a hash for a single run, or an array of hashes, each array item a hash for a single run
  # see README for format and options
  def self.run_spec
    [
      {
        link_defendant: true,
        defendant_response: :full_admission_by_set_date,
        # claimant_response: :accept_repayment_with_ccj
      }
    ]
  end
end