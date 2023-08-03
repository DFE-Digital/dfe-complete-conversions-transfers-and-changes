class Transfer::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  alias_attribute :transfer_date, :significant_date
  alias_attribute :transfer_date_provisional, :significant_date_provisional

  validates :outgoing_trust_ukprn, presence: true
  validates :outgoing_trust_ukprn, ukprn: true
  validate :outgoing_trust_exists, if: -> { outgoing_trust_ukprn.present? }

  def outgoing_trust
    @outgoing_trust ||= fetch_trust(outgoing_trust_ukprn)
  end

  def completable?
    return true if confirmed_date_and_in_the_past?
    false
  end

  def all_conditions_met?
    # TODO: Replace with task value once task data is added
    false
  end

  private def outgoing_trust_exists
    outgoing_trust
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:outgoing_trust_ukprn, :no_trust_found)
  end
end
