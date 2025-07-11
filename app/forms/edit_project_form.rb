class EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attr_accessor :project, :user

  attribute :establishment_sharepoint_link, :string
  attribute :incoming_trust_sharepoint_link, :string
  attribute :incoming_trust_ukprn, :integer
  attribute :new_trust_reference_number, :string
  attribute :new_trust_name, :string
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions, :string
  attribute :two_requires_improvement, :boolean
  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :handover_note_body, :string
  attribute :group_id, :string

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :incoming_trust_ukprn, presence: true, ukprn: true, unless: -> { new_trust_reference_number.present? }
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.attributes.two_requires_improvement.inclusion")}

  validates_with GroupIdValidator

  private def update_handover_note
    note = Note.find_or_initialize_by(project: project, task_identifier: :handover, user: user)
    note.update!(body: handover_note_body)
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_conversion_project_created(team_leader, project).deliver_later if team_leader.active
    end
  end

  private def group_id_to_group(group_id)
    return if group_id.blank?

    project.group = ProjectGroup.find_or_create_by(
      group_identifier: group_id,
      trust_ukprn: incoming_trust_ukprn
    )
  end
end
