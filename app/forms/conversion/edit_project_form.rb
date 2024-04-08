class Conversion::EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attr_accessor :project

  attribute :establishment_sharepoint_link
  attribute :incoming_trust_sharepoint_link
  attribute :incoming_trust_ukprn
  attribute :advisory_board_date, :date
  attribute :advisory_board_conditions
  attribute :directive_academy_order, :boolean
  attribute :two_requires_improvement, :boolean

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :incoming_trust_ukprn, presence: true, ukprn: true
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates :advisory_board_date, presence: true
  validates :advisory_board_date, date_in_the_past: true

  validates :directive_academy_order, inclusion: {in: [true, false]}

  validates :two_requires_improvement, inclusion: {in: [true, false], message: I18n.t("errors.conversion_project.attributes.two_requires_improvement.inclusion")}

  def self.new_from_project(project)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      incoming_trust_ukprn: project.incoming_trust_ukprn,
      advisory_board_date: project.advisory_board_date,
      advisory_board_conditions: project.advisory_board_conditions,
      directive_academy_order: project.directive_academy_order,
      two_requires_improvement: project.two_requires_improvement
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
      incoming_trust_ukprn: incoming_trust_ukprn,
      advisory_board_date: advisory_board_date,
      advisory_board_conditions: advisory_board_conditions,
      directive_academy_order: directive_academy_order,
      two_requires_improvement: two_requires_improvement
    )

    project.save!
  end
end
