class Conversion::Task::RiskProtectionArrangementTaskForm < BaseTaskForm
  attribute :option
  attribute :reason

  validates :option, inclusion: {in: %w[standard church_or_trust commercial]}
  validates :reason,
    presence: {message: I18n.t("conversion.task.risk_protection_arrangement.reason.errors.blank")},
    if: -> { option.eql?("commercial") }

  def completed?
    return true if option.eql?("standard") || option.eql?("church_or_trust")
    return true if option.eql?("commercial") && reason.present?

    false
  end
end
