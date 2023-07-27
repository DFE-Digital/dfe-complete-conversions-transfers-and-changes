class SignificantDateHistory < ApplicationRecord
  belongs_to :project, class_name: "Project"
  has_one :note, dependent: :destroy, foreign_key: :significant_date_history_id

  validates :previous_date, :revised_date, presence: true
end
