class ProjectPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @record = project
  end

  def index?
    true
  end

  def completed?
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

  def openers?
    true
  end

  def change_conversion_date?
    @record.conversion_date_provisional? == false
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

    private

    attr_reader :user, :scope
  end
end
