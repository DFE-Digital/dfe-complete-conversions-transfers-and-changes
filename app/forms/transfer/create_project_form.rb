class Transfer::CreateProjectForm < CreateProjectForm
  attr_reader :provisional_transfer_date

  attribute :outgoing_trust_sharepoint_link

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :provisional_transfer_date, presence: true
  validates :provisional_transfer_date, date_in_the_future: true, first_day_of_month: true

  validate :urn_unique_for_in_progress_transfers, if: -> { urn.present? }

  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validate :check_incoming_trust_and_outgoing_trust
  validate :outgoing_trust_exists, if: -> { outgoing_trust_ukprn.present? }

  def initialize(params = {})
    @attributes_with_invalid_values = []
    super(params)
  end

  def save
    @project = Transfer::Project.new(
      urn: urn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      transfer_date: provisional_transfer_date,
      regional_delivery_officer_id: user.id,
      team: user.team,
      assigned_to: user,
      assigned_at: DateTime.now,
      region: region,
      tasks_data: Transfer::TasksData.new
    )

    return nil unless valid?

    ActiveRecord::Base.transaction do
      @project.save
      @note = Note.create(body: handover_note_body, project: @project, user: user, task_identifier: :handover) if handover_note_body
    end

    @project
  end

  def provisional_transfer_date=(hash)
    @provisional_transfer_date = Date.new(value_at_position(hash, 1), value_at_position(hash, 2), value_at_position(hash, 3))
  rescue NoMethodError
    nil
  rescue TypeError, Date::Error, NegativeValueError
    @attributes_with_invalid_values << :provisional_transfer_date
  end

  def check_incoming_trust_and_outgoing_trust
    errors.add(:incoming_trust_ukprn, I18n.t("errors.attributes.incoming_trust_ukprn.ukprns_must_not_match")) if incoming_trust_ukprn == outgoing_trust_ukprn
  end

  private def outgoing_trust_exists
    result = Api::AcademiesApi::Client.new.get_trust(outgoing_trust_ukprn)
    raise result.error if result.error.present?
  rescue Api::AcademiesApi::Client::NotFoundError
    errors.add(:outgoing_trust_ukprn, :no_trust_found)
  end
end
