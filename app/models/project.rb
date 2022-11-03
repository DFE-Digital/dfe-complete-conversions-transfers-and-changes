class Project < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :contacts, dependent: :destroy

  belongs_to :caseworker, class_name: "User", optional: true
  belongs_to :team_leader, class_name: "User", optional: true
  belongs_to :regional_delivery_officer, class_name: "User", optional: true

  scope :by_target_completion_date, -> { order(target_completion_date: :asc) }

  # This works under MSSQL because it puts NULL at the front, and we can't make it more robust because TinyTDS won't
  # play nicely with things like IS NULL and NULLS LAST. If you're running this under a different database and the
  # order is suddenly inverted, go check out https://michaeljherold.com/articles/null-based-ordering-in-activerecord/
  # and see if you can use Arel to build a proper query.
  scope :by_closed_state, -> { order(:closed_at) }

  def establishment
    @establishment ||= fetch_establishment(urn)
  end

  def incoming_trust
    @incoming_trust ||= fetch_trust(incoming_trust_ukprn)
  end

  def closed?
    closed_at.present?
  end

  private def fetch_establishment(urn)
    result = AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end

  private def fetch_trust(ukprn)
    result = AcademiesApi::Client.new.get_trust(ukprn)
    raise result.error if result.error.present?

    result.object
  end
end
