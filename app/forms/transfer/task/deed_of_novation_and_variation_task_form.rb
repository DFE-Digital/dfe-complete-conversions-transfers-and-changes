class Transfer::Task::DeedOfNovationAndVariationTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed_outgoing_trust, :boolean
  attribute :signed_incoming_trust, :boolean
  attribute :saved, :boolean
  attribute :signed_secretary_state, :boolean
  attribute :sent, :boolean
end
