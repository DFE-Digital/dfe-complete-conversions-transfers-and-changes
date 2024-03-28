class Conversion::Task::ChairOfGovernorsContactTaskForm < BaseTaskForm
  attribute :name
  attribute :email
  attribute :phone

  validates :email,
    format: {with: URI::MailTo::EMAIL_REGEXP, message: I18n.t("conversion.task.chair_of_governors_contact.errors.email.format")},
    allow_blank: true

  validate :name_and_email_both_present?

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    @contact = @project.chair_of_governors_contact || Contact::Project.new

    assign_attributes(
      name: @contact.name,
      email: @contact.email,
      phone: @contact.phone
    )
  end

  def save
    if valid? && name.present? && email.present?
      @contact.assign_attributes(
        title: "Chair of governors",
        category: :school_or_academy,
        organisation_name: @project.establishment.name,
        name: name,
        email: email,
        phone: phone,
        project_id: @project.id,
        establishment_urn: @project.urn
      )
      @contact.save!

      @project.update!(chair_of_governors_contact: @contact)
    end
  end

  def completed?
    @project.chair_of_governors_contact.present?
  end

  private def name_and_email_both_present?
    errors.add(:name, I18n.t("conversion.task.chair_of_governors_contact.errors.name.presence")) if name.blank? && email.present?
    errors.add(:email, I18n.t("conversion.task.chair_of_governors_contact.errors.email.presence")) if email.blank? && name.present?
  end
end
