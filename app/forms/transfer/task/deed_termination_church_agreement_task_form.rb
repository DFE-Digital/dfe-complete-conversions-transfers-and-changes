class Transfer::Task::DeedTerminationChurchAgreementTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed_outgoing_trust, :boolean
  attribute :signed_diocese, :boolean
  attribute :saved, :boolean
  attribute :signed_secretary_state, :boolean
  attribute :saved_after_signing_by_secretary_state, :boolean
  attribute :not_applicable, :boolean
end
