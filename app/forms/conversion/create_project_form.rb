class Conversion::CreateProjectForm
  include ActiveModel::Model
  include ActiveRecord::AttributeAssignment

  SHAREPOINT_URLS = %w[educationgovuk-my.sharepoint.com educationgovuk.sharepoint.com].freeze

  attr_accessor :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link,
    :advisory_board_conditions,
    :note_body,
    :user

  attr_reader :provisional_conversion_date,
    :advisory_board_date

  validates :urn,
    :incoming_trust_ukprn,
    :establishment_sharepoint_link,
    :trust_sharepoint_link,
    :provisional_conversion_date,
    :advisory_board_date,
    presence: true

  validates :urn, urn: true
  validates :incoming_trust_ukprn, ukprn: true

  validates :provisional_conversion_date, date_in_the_future: true
  validates :provisional_conversion_date, first_day_of_month: true
  validates :advisory_board_date, date_in_the_past: true

  validates :establishment_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}
  validates :trust_sharepoint_link, presence: true, url: {hostnames: SHAREPOINT_URLS}

  validate :multiparameter_date_attributes_values

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def provisional_conversion_date=(hash)
    @provisional_conversion_date = Date.new(year_for(hash), month_for(hash), day_for(hash))
  rescue NoMethodError
    nil
  rescue TypeError
    @attributes_with_invalid_values << :provisional_conversion_date
  end

  def advisory_board_date=(hash)
    @advisory_board_date = Date.new(year_for(hash), month_for(hash), day_for(hash))
  rescue NoMethodError
    nil
  rescue TypeError
    @attributes_with_invalid_values << :advisory_board_date
  end

  private def day_for(value)
    value[3]
  end

  private def month_for(value)
    value[2]
  end

  private def year_for(value)
    value[1]
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
end
