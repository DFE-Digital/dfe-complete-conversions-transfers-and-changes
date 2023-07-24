class SignificantDateHistory < ApplicationRecord
  self.table_name = "conversion_date_histories"

  belongs_to :project, class_name: "Project"
  has_one :note, dependent: :destroy, foreign_key: :conversion_date_history_id

  validates :previous_date, :revised_date, presence: true
end
