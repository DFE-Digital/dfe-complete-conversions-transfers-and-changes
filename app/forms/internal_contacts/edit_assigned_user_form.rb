class InternalContacts::EditAssignedUserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email, :project, :user

  validates :email, presence: true

  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}, if: -> { email.present? }
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, if: -> { email.present? }

  validate :user_is_assignable

  def self.new_from_project(project)
    user_email = project.assigned_to_id.present? ? project.assigned_to.email : nil

    new({email: user_email, project: project})
  end

  def initialize(attrs = {})
    super
    self.user = User.assignable.find_by_email(email)
  end

  def update
    if valid?
      result = project.update(assigned_to: user)
      send_assigned_email

      result
    else
      false
    end
  end

  private def user_is_assignable
    if user.blank?
      errors.add(:email, :not_assignable)
    end
  end

  private def send_assigned_email
    AssignedToMailer.assigned_notification(user, @project).deliver_later if user.active
  end
end
