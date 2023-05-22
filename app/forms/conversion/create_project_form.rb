class Conversion::CreateProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  class NegativeValueError < StandardError; end

  attribute :urn, :integer
  attribute :incoming_trust_ukprn, :integer
  attribute :establishment_sharepoint_link
  attribute :trust_sharepoint_link
  attribute :advisory_board_conditions
  attribute :handover_note_body
  attribute :user
  attribute :directive_academy_order, :boolean
  attribute :region
  attribute :assigned_to_regional_caseworker_team, :boolean

  attr_reader :provisional_conversion_date,
    :advisory_board_date

  validates :provisional_conversion_date,
    :advisory_board_date,
    :handover_note_body,
    presence: true

  validates :provisional_conversion_date, date_in_the_future: true, first_day_of_month: true
  validates :advisory_board_date, date_in_the_past: true

  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}

  validates :urn, presence: true, urn: true
  validates :incoming_trust_ukprn, presence: true, ukprn: true

  validate :multiparameter_date_attributes_values

  validate :establishment_exists, if: -> { urn.present? }
  validate :trust_exists, if: -> { incoming_trust_ukprn.present? }

  validate :urn_unique_for_in_progress_conversions, if: -> { urn.present? }

  validates :directive_academy_order, :assigned_to_regional_caseworker_team, inclusion: {in: [true, false]}

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def provisional_conversion_date=(hash)
    @provisional_conversion_date = Date.new(value_at_position(hash, 1), value_at_position(hash, 2), value_at_position(hash, 3))
  rescue NoMethodError
    nil
  rescue TypeError, Date::Error
    @attributes_with_invalid_values << :provisional_conversion_date
  end

  def advisory_board_date=(hash)
    @advisory_board_date = Date.new(value_at_position(hash, 1), value_at_position(hash, 2), value_at_position(hash, 3))
  rescue NoMethodError
    nil
  rescue TypeError, Date::Error, NegativeValueError
    @attributes_with_invalid_values << :advisory_board_date
  end

  def region
    @region = establishment.region_code
  end

  private def establishment
    @establishment || fetch_establishment(urn)
  end

  private def fetch_establishment(urn)
    result = Api::AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end

  private def value_at_position(hash, position)
    value = hash[position]
    return NegativeValueError if value.to_i < 0
    value
  end

  private def multiparameter_date_attributes_values
    return if @attributes_with_invalid_values.empty?
    @attributes_with_invalid_values.each { |attribute| errors.add(attribute, :invalid) }
  end

  private def notify_team_leaders(project)
    User.team_leaders.each do |team_leader|
      TeamLeaderMailer.new_project_created(team_leader, project).deliver_later
    end
  end

  private def establishment_exists
    establishment
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def trust_exists
    result = Api::AcademiesApi::Client.new.get_trust(incoming_trust_ukprn)
    raise result.error if result.error.present?
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:incoming_trust_ukprn, :no_trust_found)
  end

  private def urn_unique_for_in_progress_conversions
    errors.add(:urn, :duplicate) if Project.not_completed.where(urn: urn).any?
  end

  def assigned_to_regional_caseworker_team_responses
    @assigned_to_regional_caseworker_team_responses ||= [
      OpenStruct.new(id: true, name: I18n.t("yes")),
      OpenStruct.new(id: false, name: I18n.t("no"))
    ]
  end

  def directive_academy_order_responses
    @directive_academy_order_responses ||= [
      OpenStruct.new(id: true, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.yes")),
      OpenStruct.new(id: false, name: I18n.t("helpers.responses.conversion_project.directive_academy_order.no"))
    ]
  end

  def save
    assigned_to = assigned_to_regional_caseworker_team ? nil : user
    assigned_at = assigned_to_regional_caseworker_team ? nil : DateTime.now

    @project = Conversion::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      trust_sharepoint_link: trust_sharepoint_link,
      advisory_board_conditions: advisory_board_conditions,
      conversion_date: provisional_conversion_date,
      advisory_board_date: advisory_board_date,
      regional_delivery_officer_id: user.id,
      assigned_to_regional_caseworker_team: assigned_to_regional_caseworker_team,
      assigned_to: assigned_to,
      assigned_at: assigned_at,
      directive_academy_order: directive_academy_order,
      region: region,
      tasks_data: Conversion::TasksData.new
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
      notify_team_leaders(@project) if assigned_to_regional_caseworker_team
    end

    @project
  end
end
