class Transfer::Task::ChurchSupplementalAgreementTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed_incoming_trust, :boolean
  attribute :signed_diocese, :boolean
  attribute :saved_after_signing_by_trust_diocese, :boolean
  attribute :signed_secretary_state, :boolean
  attribute :saved_after_signing_by_secretary_state, :boolean
end
