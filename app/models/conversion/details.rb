class Conversion::Details < ApplicationRecord
  self.table_name = "conversion_details"

  belongs_to :project, inverse_of: :details

  validates :incoming_trust_ukprn, presence: true
  validates :incoming_trust_ukprn, ukprn: true

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  private def fetch_trust(ukprn)
    result = AcademiesApi::Client.new.get_trust(ukprn)
    raise result.error if result.error.present?

    result.object
  end
end
