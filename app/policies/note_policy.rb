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
end
