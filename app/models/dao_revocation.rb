class DaoRevocation < ApplicationRecord
  belongs_to :project
  has_many :reasons,
    -> { order :reason_type },
    foreign_key: :dao_revocation_id,
    class_name: "DaoRevocationReason",
    dependent: :destroy
  has_many :notes, through: :reasons

  validates :date_of_decision, :decision_makers_name, presence: true
  validate :conversion_project_with_dao

  after_destroy :update_project_state

  private def conversion_project_with_dao
    errors.add(:base, :incorrect_project_type) unless project.is_a?(Conversion::Project) && project.directive_academy_order
  end

  private def update_project_state
    project.update(state: :active)
  end
end
