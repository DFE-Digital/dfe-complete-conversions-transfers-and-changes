class Conversion::EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :establishment_sharepoint_link
  attribute :incoming_trust_sharepoint_link
  attribute :incoming_trust_ukprn

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_ukprn, presence: true, ukprn: true

  validates :incoming_trust_ukprn, trust_exists: true, if: -> { incoming_trust_ukprn.present? }

  def initialize(project:, args: {})
    @project = project
    super(args)

    if args.empty?
      assign_attributes(
        establishment_sharepoint_link: @project.establishment_sharepoint_link,
        incoming_trust_sharepoint_link: @project.incoming_trust_sharepoint_link,
        incoming_trust_ukprn: @project.incoming_trust_ukprn
      )
    end
  end

  def save
    @project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link,
      incoming_trust_ukprn: incoming_trust_ukprn
    )
    if valid?
      @project.save
    end
  end
end
