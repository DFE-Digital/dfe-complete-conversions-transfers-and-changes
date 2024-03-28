class Conversion::EditProjectForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment

  attribute :establishment_sharepoint_link
  attribute :incoming_trust_sharepoint_link

  validates :establishment_sharepoint_link, presence: true, sharepoint_url: true
  validates :incoming_trust_sharepoint_link, presence: true, sharepoint_url: true

  def initialize(project:, args: {})
    @project = project
    super(args)

    if args.empty?
      assign_attributes(
        establishment_sharepoint_link: @project.establishment_sharepoint_link,
        incoming_trust_sharepoint_link: @project.incoming_trust_sharepoint_link
      )
    end
  end

  def save
    @project.assign_attributes(
      establishment_sharepoint_link: establishment_sharepoint_link,
      incoming_trust_sharepoint_link: incoming_trust_sharepoint_link
    )
    if valid?
      @project.save
    end
  end
end
