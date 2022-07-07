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
    user.team_leader?
  end

  def new?
    create?
  end

  def edit?
    true
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
      else
        scope.where(delivery_officer: user)
      end
    end

    private

    attr_reader :user, :scope
  end
end
