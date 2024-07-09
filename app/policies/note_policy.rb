class NotePolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @note = note
    @project = @note.project
  end

  def edit?
    return false if @project.completed?

    @note.user == @user
  end

  def update?
    edit?
  end

  def destroy?
    return false if @note.notable.present?

    edit?
  end

  def confirm_destroy?
    edit?
  end
end
