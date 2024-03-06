class Transfer::Task::ConfirmDateAcademyTransferredTaskForm < BaseOptionalTaskForm
  attribute :date_transferred, :date
  attribute "date_transferred(1i)"
  attribute "date_transferred(2i)"
  attribute "date_transferred(3i)"

  validate :govuk_three_field_date_format

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_transferred = @project.tasks_data.confirm_date_academy_transferred_date_transferred
  end

  def save
    if valid?
      @tasks_data.assign_attributes(
        confirm_date_academy_transferred_date_transferred: formatted_date
      )
      @tasks_data.save!
    end
  end

  def formatted_date
    return nil if month.blank? || year.blank? || day.blank?
    Date.new(year, month, day)
  end

  private def govuk_three_field_date_format
    return if month.blank? && year.blank? && day.blank?

    Date.new(year, month, day)
  rescue TypeError, Date::Error
    errors.add(:date_transferred, I18n.t("transfer.task.confirm_date_academy_transferred.errors.format"))
  end

  private def day
    day = attributes["date_transferred(3i)"]
    return if day.blank?

    day.to_i
  end

  private def month
    month = attributes["date_transferred(2i)"]
    return if month.blank?

    month.to_i
  end

  private def year
    year = attributes["date_transferred(1i)"]
    return false unless ("1900".."3000").to_a.include?(year)
    return if year.blank?

    year.to_i
  end

  def completed?
    date_transferred.present?
  end
end
