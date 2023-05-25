class Contact::FundingAgreementLetters < Contact
  def self.policy_class
    ContactPolicy
  end

  belongs_to :project, optional: true
end
