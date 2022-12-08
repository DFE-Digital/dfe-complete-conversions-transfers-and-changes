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

  def provisional_conversion_date=(hash)
    @provisional_conversion_date = Date.new(year_for(hash), month_for(hash), day_for(hash))
  rescue NoMethodError
    nil
  end

  def advisory_board_date=(hash)
    @advisory_board_date = Date.new(year_for(hash), month_for(hash), day_for(hash))
  rescue NoMethodError
    nil
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
end
