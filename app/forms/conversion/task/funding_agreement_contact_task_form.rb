class Conversion::Task::FundingAgreementContactTaskForm < ::BaseTaskForm
  attribute :name, :string
  attribute :email, :string
  attribute :title, :string

  validates :name, :email, :title, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    @contact = Contact::Project.find_or_create_by(project: @project, funding_agreement_contact: true)

    super(@tasks_data, @user)

    assign_attributes(
      name: @contact.name,
      title: @contact.title,
      email: @contact.email
    )
  end

  def save
    @contact.assign_attributes(
      project: @project,
      name: name,
      title: title,
      email: email,
      funding_agreement_contact: true
    )
    @contact.save!
  end
end
