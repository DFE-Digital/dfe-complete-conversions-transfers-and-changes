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
end
