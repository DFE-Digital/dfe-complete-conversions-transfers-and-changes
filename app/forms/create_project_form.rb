class CreateProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  class NegativeValueError < StandardError; end

  attribute :urn, :integer
  attribute :incoming_trust_ukprn, :integer
  attribute :outgoing_trust_ukprn, :integer
  attribute :establishment_sharepoint_link
  attribute :incoming_trust_sharepoint_link
  attribute :user
  attribute :advisory_board_conditions
  attribute :handover_note_body
  attribute :assigned_to_regional_caseworker_team, :boolean
  attribute :new_trust_reference_number
  attribute :new_trust_name
  attribute :advisory_board_date, :date
  attribute :group_id, :string

  validates :urn, presence: true, urn: true
  validates :incoming_trust_ukprn, presence: true, ukprn: true, on: :existing_trust
  validates :incoming_trust_ukprn, trust_exists: true, on: :existing_trust, if: -> { incoming_trust_ukprn.present? }

  validates_with GroupIdValidator

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :handover_note_body, presence: true, if: -> { assigned_to_regional_caseworker_team.eql?(true) }

  validate :establishment_exists, if: -> { urn.present? }

  validates :new_trust_reference_number, presence: true, on: :form_a_mat
  validates :new_trust_reference_number, trust_reference_number: true, on: :form_a_mat
  validates :new_trust_name, presence: true, on: :form_a_mat

  def initialize(attributes = {})
    # if any of the three date fields are invalid, clear them all to prevent multiparameter
    # assignment errors
    if GovukDateFieldParameters.new(:advisory_board_date, attributes).invalid?
      attributes[:"advisory_board_date(3i)"] = ""
      attributes[:"advisory_board_date(2i)"] = ""
      attributes[:"advisory_board_date(1i)"] = ""
    end

    super
  end

  def region
    @region = establishment.region_code
  end

  private def establishment
    @establishment || fetch_establishment(urn)
  end

  private def establishment_exists
    establishment
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:urn, :no_establishment_found)
  end

  private def fetch_establishment(urn)
    result = Api::AcademiesApi::Client.new.get_establishment(urn)
    raise result.error if result.error.present?

    result.object
  end

  private def urn_unique_for_in_progress_transfers
    errors.add(:urn, :duplicate) if Transfer::Project.active.where(urn: urn).any?
  end
end
