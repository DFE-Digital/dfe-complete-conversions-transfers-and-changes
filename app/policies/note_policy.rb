class NotePolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @record = note
  end

  def create?
    true
  end

  def new?
    create?
  end

  def edit?
    @record.user == @user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def confirm_destroy?
    edit?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
