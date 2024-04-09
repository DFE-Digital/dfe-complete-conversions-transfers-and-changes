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

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true
  validates :outgoing_trust_sharepoint_link, presence: true, sharepoint_url: true

  validates :outgoing_trust_ukprn, presence: true, ukprn: true
  validates :outgoing_trust_ukprn, trust_exists: true, if: -> { outgoing_trust_ukprn.present? }

  validates :incoming_trust_ukprn, presence: true, ukprn: true
  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  validates_with OutgoingIncomingTrustsUkprnValidator

  def self.new_from_project(project)
    new(
      project: project,
      establishment_sharepoint_link: project.establishment_sharepoint_link,
      incoming_trust_sharepoint_link: project.incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: project.outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: project.outgoing_trust_ukprn,
      incoming_trust_ukprn: project.incoming_trust_ukprn
    )
  end

  def update(params)
    assign_attributes(params)

    return false unless valid?

    project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      outgoing_trust_sharepoint_link: outgoing_trust_sharepoint_link,
      outgoing_trust_ukprn: outgoing_trust_ukprn,
      incoming_trust_ukprn: incoming_trust_ukprn
    )
    if valid?
      project.save
    end
  end
end
