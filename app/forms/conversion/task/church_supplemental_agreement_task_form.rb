class Conversion::Task::ChurchSupplementalAgreementTaskForm < BaseOptionalTaskForm
  attribute :received, :boolean
  attribute :cleared, :boolean
  attribute :signed, :boolean
  attribute :signed_diocese, :boolean
  attribute :saved, :boolean
  attribute :sent, :boolean
  attribute :signed_secretary_state, :boolean
end
