class SignificantDateHistory < ApplicationRecord
  belongs_to :project, class_name: "Project"
  belongs_to :user
  has_one :note, dependent: :destroy, foreign_key: :significant_date_history_id
  has_many :reasons, -> { order :reason_type }, dependent: :destroy, foreign_key: :significant_date_history_id, class_name: "SignificantDateHistoryReason"

  validates :previous_date, :revised_date, presence: true
end
