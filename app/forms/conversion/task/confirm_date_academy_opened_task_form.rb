class Conversion::Task::ConfirmDateAcademyOpenedTaskForm < BaseTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :date_opened, :date

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_opened = @project.tasks_data.confirm_date_academy_opened_date_opened
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:date_opened, attributes).invalid?
      @date_param_errors.add(:date_opened, I18n.t("conversion.task.confirm_date_academy_opened.errors.opened_date.invalid"))

      attributes.delete("date_opened(3i)")
      attributes.delete("date_opened(2i)")
      attributes.delete("date_opened(1i)")
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
        confirm_date_academy_opened_date_opened: date_opened
      )
      @tasks_data.save!
    end
  end
end
