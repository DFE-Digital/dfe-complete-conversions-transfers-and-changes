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
    true
  end

  def create?
    user.add_new_project?
  end

  def edit?
    return false if @record.completed?

    true
  end

  def check?
    return false if @record.completed?

    true
  end

  def update_academy_urn?
    return false if @record.completed?

    true
  end

  def new?
    create?
  end

  def update?
    return false if @record.completed?

    project_assigned_to_user?
  end

  def change_conversion_date?
    return false if @record.conversion_date_provisional?

    project_assigned_to_user?
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
    true
  end

  private def project_assigned_to_user?
    @record.assigned_to == @user
  end

  private def edit_project_closed?
    return false if @record.completed?

    true
  end
end
