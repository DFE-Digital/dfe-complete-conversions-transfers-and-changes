class ProjectGroup < ApplicationRecord
  include ApplicationInsightsEventTrackable

  has_many :projects, foreign_key: :group_id

  def trust
    @trust ||= fetch_trust_by_ukprn(trust_ukprn)
  end

  private def fetch_trust_by_ukprn(ukprn)
    result = Api::AcademiesApi::Client.new.get_trust(ukprn)

    if result.error.present?
      track_event(result.error.message)
      return Api::AcademiesApi::Trust.new.from_hash({referenceNumber: "", name: result.error.message})
    end

    result.object
  end
end
