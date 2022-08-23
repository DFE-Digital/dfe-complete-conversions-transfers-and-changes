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

  def edit?
    user.team_leader?
  end

  def update?
    edit?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.team_leader?
        scope.all
      elsif user.regional_delivery_officer?
        scope.where(regional_delivery_officer: user)
      else
        scope.where(caseworker: user)
      end
    end

    private

    attr_reader :user, :scope
  end
end
