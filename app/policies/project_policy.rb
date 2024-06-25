class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @record = project
  end

  def index?
    true
  end

  def show?
    return false if @record.deleted?

    true
  end

  def create?
    user.add_new_project?
  end

  def edit?
    return false if @record.deleted?
    return true if @user.is_service_support?
    return false if @record.completed?

    true
  end

  def dao_revocation?
    update?
  end

  def check?
    edit?
  end

  def update_academy_urn?
    edit?
  end

  def new?
    create?
  end

  def new_mat?
    new?
  end

  def create_mat?
    create?
  end

  def update?
    return true if @user.is_service_support?
    return false if @record.completed?

    project_assigned_to_user?
  end

  def change_significant_date?
    return true if @user.is_service_support?
    return false if @record.significant_date_provisional?

    project_assigned_to_user?
  end

  def change_conversion_date?
    @record.is_a?(Conversion::Project) && change_significant_date?
  end

  def change_transfer_date?
    @record.is_a?(Transfer::Project) && change_significant_date?
  end

  def new_note?
    return false unless @user.has_role?

    edit_project_closed?
  end

  def new_contact?
    return false unless @user.has_role?

    edit_project_closed?
  end

  def update_assigned_to?
    edit_project_closed?
  end

  def update_regional_delivery_officer?
    edit_project_closed?
  end

  def unassigned?
    @user.manage_team?
  end

  def handed_over?
    @user.team != "regional_casework_services"
  end

  def delete?
    @user.is_service_support?
  end

  private def project_assigned_to_user?
    @record.assigned_to == @user
  end

  private def edit_project_closed?
    return false if @record.completed?

    true
  end
end
