class NotePolicy
  attr_reader :user, :note

  def initialize(user, note)
    @user = user
    @record = note
  end

  def index?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

end
