class Transfer::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  alias_attribute :transfer_date, :significant_date
  alias_attribute :transfer_date_provisional, :significant_date_provisional

  validates :outgoing_trust_ukprn, presence: true
  validates :outgoing_trust_ukprn, ukprn: true

  MANDATORY_CONDITIONS = [
    :confirmed_date_and_in_the_past?
  ]

  alias_attribute :authority_to_proceed, :all_conditions_met

  def outgoing_trust
    @outgoing_trust ||= fetch_trust(outgoing_trust_ukprn)
  end

  def completable?
    MANDATORY_CONDITIONS.all? { |task| send(task) }
  end
end
