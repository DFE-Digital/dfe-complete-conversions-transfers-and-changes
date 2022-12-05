class Conversion::Voluntary::CreateProjectForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  attr_accessor :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link,
    :advisory_board_conditions,
    :note_body,
    :user,
    :provisional_conversion_date,
    :advisory_board_date

  validates :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link,
    :advisory_board_date,
    :provisional_conversion_date, presence: true

  validates :urn, urn: true
  validates :incoming_trust_ukprn, ukprn: true

  validates :provisional_conversion_date, date_in_the_future: true
  validates :provisional_conversion_date, first_day_of_month: true
  validates :advisory_board_date, date_in_the_past: true

  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}

  def save
    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      trust_sharepoint_link: trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      provisional_conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id
    )

    if valid?
      ActiveRecord::Base.transaction do
        @project.save
        @note = Note.create(body: note_body, project: @project, user: user) if note_body
        Conversion::Voluntary::Details.create(project: @project)
        TaskListCreator.new.call(@project, workflow_root: Conversion::Voluntary::Details::WORKFLOW_PATH)
        true
      end
    end
  end
end
