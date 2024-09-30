class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    true
  end

  def handover?
    @user.is_regional_delivery_officer?
  end

  def show?
    return false if @project.deleted?

    true
  end

  def new?
    user.add_new_project?
  end

  def create?
    new?
  end

  def new_mat?
    new?
  end

  def create_mat?
    new?
  end

  def edit?
    return false if @project.deleted?

    return true if @user.is_service_support?

    return false if @project.completed?
    return false if @project.dao_revoked?

    project_assigned_to_user?
  end

  def update?
    edit?
  end

  def dao_revocation?
    edit?
  end

  def check?
    edit?
  end

  def update_academy_urn?
    edit?
  end

  def change_significant_date?
    return false if @project.significant_date_provisional?

    edit?
  end

  def change_conversion_date?
    return false unless @project.is_a?(Conversion::Project)

    change_significant_date?
  end

  def change_transfer_date?
    return false unless @project.is_a?(Transfer::Project)

    change_significant_date?
  end

  def new_note?
    return false unless @user.has_role?
    return false if project_finished?

    true
  end

  def new_contact?
    return false unless @user.has_role?
    return false if project_finished?

    true
  end

  def update_assigned_to?
    re_assignable?
  end

  def update_regional_delivery_officer?
    re_assignable?
  end

  def delete?
    @user.is_service_support?
  end

  # Unassigned action in Team::ProjectsController
  def unassigned?
    @user.manage_team?
  end

  # Handed over action in Team::ProjectsController
  def handed_over?
    @user.team != "regional_casework_services"
  end

  private def project_assigned_to_user?
    @project.assigned_to == @user
  end

  private def project_finished?
    return true if @project.completed?
    return true if @project.deleted?
    return true if @project.dao_revoked?

    false
  end

  private def re_assignable?
    return false if project_finished?

    true
  end
end
