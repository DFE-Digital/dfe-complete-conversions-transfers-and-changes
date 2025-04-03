class InternalContacts::EditAddedByUserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :email, :project, :user

  validates :email, presence: true

  validates :email, format: {with: /\A\S+@education.gov.uk\z/i}, if: -> { email.present? }
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, if: -> { email.present? }

  validate :user_is_assignable

  def self.new_from_project(project)
    new({email: project.regional_delivery_officer.email, project: project})
  end

  def initialize(attrs = {})
    super
    self.user = User.assignable.find_by_email(email)
  end

  def update
    if valid?
      project.update(regional_delivery_officer: user)
    else
      false
    end
  end

  private def user_is_assignable
    if user.blank?
      errors.add(:email, :not_assignable)
    end
  end
end
