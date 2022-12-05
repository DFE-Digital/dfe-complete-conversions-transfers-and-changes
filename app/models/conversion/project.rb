class Conversion::Project < Project
  has_one :details, class_name: "Conversion::Details", dependent: :destroy
  delegate :incoming_trust, to: :details
  accepts_nested_attributes_for :details

  validate :establishment_exists, :trust_exists, on: :create

  def self.policy_class
    ProjectPolicy
  end

  private def trust_exists
    incoming_trust
  rescue AcademiesApi::Client::NotFoundError
    errors.add(:incoming_trust_ukprn, :no_trust_found)
  end
end
