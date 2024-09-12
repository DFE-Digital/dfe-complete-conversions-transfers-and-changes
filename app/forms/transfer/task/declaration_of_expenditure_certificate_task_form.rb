class Transfer::Task::DeclarationOfExpenditureCertificateTaskForm < BaseOptionalTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :date_received, :date
  attribute :correct, :boolean
  attribute :saved, :boolean

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_received = @project.tasks_data.declaration_of_expenditure_certificate_date_received
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:date_received, attributes).invalid?
      @date_param_errors.add(
        :date_received,
        I18n.t("transfer.task.declaration_of_expenditure_certificate.date_received.errors.invalid")
      )

      attributes.delete("date_received(3i)")
      attributes.delete("date_received(2i)")
      attributes.delete("date_received(1i)")
    end

    super
  end

  def valid?(context = nil)
    super
    errors.merge!(@date_param_errors)
    errors.empty?
  end
end
