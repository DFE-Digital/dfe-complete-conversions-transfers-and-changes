class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @record = project
  end

  def index?
    true
  end

  def unassigned?
    user.team_leader?
  end

  def show?
    true
  end

  def create?
    user.regional_delivery_officer?
  end

  def new?
    create?
  end

  def update?
    return false if @record.completed?

    project_assigned_to_user?
  end

  def openers?
    true
  end

  def change_conversion_date?
    return false if @record.conversion_date_provisional?

    project_assigned_to_user?
  end

  def new_note?
    edit_project_closed?
  end

  def new_contact?
    edit_project_closed?
  end

  def update_assigned_to?
    edit_project_closed?
  end

  def update_regional_delivery_officer?
    edit_project_closed?
  end

  private def project_assigned_to_user?
    @record.assigned_to == @user
  end

  private def edit_project_closed?
    return false if @record.completed?

    true
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.team_leader?
        scope.conversions.by_conversion_date
      elsif user.regional_delivery_officer?
        scope.conversions.by_conversion_date.assigned_to_regional_delivery_officer(user)
      else
        scope.conversions.by_conversion_date.assigned_to_caseworker(user)
      end
    end

    private attr_reader :user, :scope
  end
end
