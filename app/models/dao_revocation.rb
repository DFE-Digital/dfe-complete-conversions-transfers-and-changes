class DaoRevocation < ApplicationRecord
  belongs_to :project

  validates :date_of_decision, :decision_makers_name, presence: true
  validate :conversion_project_with_dao
  validate :at_least_one_reason

  private def at_least_one_reason
    errors.add(:base, :reason_required) unless reason_school_closed || reason_school_rating_improved || reason_safeguarding_addressed
  end

  private def conversion_project_with_dao
    errors.add(:base, :incorrect_project_type) unless project.is_a?(Conversion::Project) && project.directive_academy_order
  end
end
