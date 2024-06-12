class Transfer::Task::ConfirmDateAcademyTransferredTaskForm < BaseOptionalTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :date_transferred, :date

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_transferred = @project.tasks_data.confirm_date_academy_transferred_date_transferred
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:date_transferred, attributes).invalid?
      @date_param_errors.add(:date_transferred, I18n.t("transfer.task.confirm_date_academy_transferred.errors.invalid"))

      attributes.delete("date_transferred(3i)")
      attributes.delete("date_transferred(2i)")
      attributes.delete("date_transferred(1i)")
    end

    super
  end

  def valid?(context = nil)
    super
    errors.merge!(@date_param_errors)
    errors.empty?
  end

  def save
    if valid?
      @tasks_data.assign_attributes(
        confirm_date_academy_transferred_date_transferred: date_transferred
      )
      @tasks_data.save!
    end
  end
end
