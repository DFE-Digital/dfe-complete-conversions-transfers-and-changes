class SignificantDateHistoryReason < ApplicationRecord
  belongs_to :significant_date_history, class_name: "SignificantDateHistory"
  has_one :note, required: true, dependent: :destroy, foreign_key: :significant_date_history_reason_id

  validates :reason_type, presence: true
end
