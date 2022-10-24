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
    user.regional_delivery_officer?
  end

  def new?
    create?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.team_leader?
        scope.by_closed_state.by_target_completion_date
      elsif user.regional_delivery_officer?
        scope.by_closed_state.by_target_completion_date.where(regional_delivery_officer: user)
      else
        scope.by_closed_state.by_target_completion_date.where(caseworker: user)
      end
    end

    private

    attr_reader :user, :scope
  end
end
