class SignificantDateHistoryReason < ApplicationRecord
  belongs_to :significant_date_history, class_name: "SignificantDateHistory"
  has_one :note, required: true, dependent: :destroy, foreign_key: :significant_date_history_reason_id

  validates :reason_type, presence: true

  enum :reason_type, {
    legacy_reason: "legacy_reason",
    stakeholder_kick_off: "stakeholder_kick_off"
  }
end
