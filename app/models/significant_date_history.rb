class SignificantDateHistory < ApplicationRecord
  belongs_to :project, class_name: "Project"
  has_one :note, dependent: :destroy, foreign_key: :significant_date_history_id
  has_many :reasons, dependent: :destroy, foreign_key: :significant_date_history_id, class_name: "SignificantDateHistoryReason"

  validates :previous_date, :revised_date, presence: true
end
