class FormAMultiAcademyTrust::ProjectGroup
  def self.policy_class
    ProjectPolicy
  end

  class NoProjectsFoundError < StandardError
  end

  attr_accessor :trn, :name, :projects, :region, :assigned_to

  def initialize(trn:)
    @trn = trn
    @projects = fetch_projects

    raise NoProjectsFoundError, "No projects with #{@trn} could be found" if @projects.empty?

    @name = fetch_trust_name
    @region = fetch_region
    @assigned_to = fetch_assigned_to
  end

  def deleted?
    false
  end

  private def fetch_assigned_to
    @projects.order(:created_at).first.assigned_to
  end

  private def fetch_region
    @projects.order(:created_at).first.region
  end

  private def fetch_trust_name
    @projects.order(:created_at).first.new_trust_name
  end

  private def fetch_projects
    Project.where(new_trust_reference_number: @trn).includes(:assigned_to)
  end
end
