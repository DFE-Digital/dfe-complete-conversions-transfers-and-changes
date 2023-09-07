class Transfer::Task::DeedOfTerminationForTheMasterFundingAgreementTaskForm < BaseOptionalTaskForm
  attribute :not_applicable, :boolean
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :saved_academy_and_outgoing_trust_sharepoint, :boolean
  attribute :contact_financial_reporting_team, :boolean
  attribute :signed_secretary_state, :boolean
  attribute :saved_in_academy_sharepoint_folder, :boolean
end
