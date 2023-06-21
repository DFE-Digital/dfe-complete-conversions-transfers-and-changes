class ContactPolicy
  attr_reader :user, :contact

  def initialize(user, contact)
    @user = user
    @contact = contact
    @project = @contact.project if contact.instance_of?(Contact::Project)
  end

  def edit?
    return false if @project&.completed?
    return false unless @user.has_role?

    true
  end

  def update?
    edit?
  end

  def destroy?
    return false if @project&.completed?
    return false unless @user.has_role?

    true
  end

  def confirm_destroy?
    destroy?
  end
end
