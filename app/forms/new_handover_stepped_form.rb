class NewHandoverSteppedForm
  include Teamable
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :handover_note_body, :string
  attribute :establishment_sharepoint_link, :string
  attribute :incoming_trust_sharepoint_link, :string
  attribute :outgoing_trust_sharepoint_link, :string
  attribute :two_requires_improvement, :boolean
  attribute :team, :string
  attribute :email, :string

  validates :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}

  validates :handover_note_body, presence: true

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true, if: -> { @project.is_a?(Transfer::Project) }

  validates :two_requires_improvement, inclusion: {in: [true, false]}, if: -> { @project.is_a?(Conversion::Project) }

  validates :team, presence: true, inclusion: {in: regional_teams}, on: :assign

  validates :email, presence: true, on: :assign
  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}, if: -> { email.present? }
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, if: -> { email.present? }
  validate :email_exists, on: :assign, if: -> { email.present? }

  def self.list_of_teams
    regional_teams.sort.map do |team|
      OpenStruct.new(id: team, name: I18n.t("teams.#{team}"))
    end
  end

  def initialize(project, user, args = {})
    @user = user
    @project = project
    super(args)
  end

  def save
    @project.assign_attributes({
      team: team || :regional_casework_services,
      assigned_to_id: assigned_user_id,
      assigned_at: DateTime.now,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      two_requires_improvement: two_requires_improvement,
      state: :active
    })
    @project.save!

    create_handover_note!
  end

  private def email_exists
    errors.add(:email, :email_does_not_exist) unless assigned_user_id
  end

  private def assigned_user_id
    return unless email

    User.find_by_email(email)&.id
  end

  private def create_handover_note!
    Note.create!(body: handover_note_body, project: @project, user: @user, task_identifier: :handover)
  end
end
