class Transfer::EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attr_accessor :project

  attribute :establishment_sharepoint_link
  attribute :outgoing_trust_sharepoint_link
  attribute :incoming_trust_sharepoint_link
  attribute :outgoing_trust_ukprn
  attribute :incoming_trust_ukprn
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions
  attribute :two_requires_improvement, :boolean
  attribute :inadequate_ofsted, :boolean
  attribute :financial_safeguarding_governance_issues, :boolean

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true
  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :outgoing_trust_ukprn, trust_exists: true, if: -> { outgoing_trust_ukprn.present? }

  validates :incoming_trust_ukprn, presence: true, ukprn: true
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates_with OutgoingIncomingTrustsUkprnValidator

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  validates :inadequate_ofsted, inclusion: {in: [true, false], message: I18n.t("errors.transfer_project.attributes.inadequate_ofsted.inclusion")}

  def self.new_from_project(project)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: project.outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: project.outgoing_trust_ukprn,
      incoming_trust_ukprn: project.incoming_trust_ukprn,
      advisory_board_date: project.advisory_board_date,
      advisory_board_conditions: project.advisory_board_conditions,
      two_requires_improvement: project.two_requires_improvement,
      inadequate_ofsted: project.tasks_data.inadequate_ofsted,
      financial_safeguarding_governance_issues: project.tasks_data.financial_safeguarding_governance_issues
    )
  end

  def update(params)
    if GovukDateFieldParameters.new(:advisory_board_date, params).invalid?
      errors.add(:advisory_board_date, :invalid)
      return false
    end

    assign_attributes(params)

    return false unless valid?

    project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      incoming_trust_ukprn: incoming_trust_ukprn,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      two_requires_improvement: two_requires_improvement
    )

    project.tasks_data.assign_attributes(
      inadequate_ofsted: inadequate_ofsted,
      financial_safeguarding_governance_issues: financial_safeguarding_governance_issues
    )

    if valid?
      project.save!
      project.tasks_data.save!
    end
  end
end
