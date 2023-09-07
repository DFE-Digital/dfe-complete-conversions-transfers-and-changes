class Transfer::Task::DeedOfNovationAndVariationTaskForm < BaseTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed_outgoing_trust, :boolean
  attribute :signed_incoming_trust, :boolean
  attribute :saved, :boolean
  attribute :signed_secretary_state, :boolean
  attribute :save_after_sign, :boolean
end
