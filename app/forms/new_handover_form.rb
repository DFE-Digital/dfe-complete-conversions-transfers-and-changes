class NewHandoverForm
  include Teamable
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :handover_note_body, :string
  attribute :establishment_sharepoint_link, :string
  attribute :incoming_trust_sharepoint_link, :string
  attribute :outgoing_trust_sharepoint_link, :string
  attribute :two_requires_improvement, :boolean

  validates :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}

  validates :handover_note_body, presence: true, if: -> { assigned_to_regional_caseworker_team }

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true, if: -> { @project.is_a?(Transfer::Project) }

  validates :two_requires_improvement, inclusion: {in: [true, false]}, if: -> { @project.is_a?(Conversion::Project) }

  def initialize(project, user, args = {})
    @user = user
    @project = project
    super(args)
  end

  def save
    @project.assign_attributes({
      team: assigned_team,
      assigned_to_id: assigned_user_id,
      assigned_at: DateTime.now,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      two_requires_improvement: two_requires_improvement,
      state: :active
    })
    @project.save!

    create_handover_note! if handover_note_body.present?
  end

  private def assigned_team
    return :regional_casework_services if assigned_to_regional_caseworker_team

    @user.team
  end

  private def assigned_user_id
    return if assigned_to_regional_caseworker_team

    @user.id
  end

  private def create_handover_note!
    Note.create!(body: handover_note_body, project: @project, user: @user, task_identifier: :handover)
  end
end
