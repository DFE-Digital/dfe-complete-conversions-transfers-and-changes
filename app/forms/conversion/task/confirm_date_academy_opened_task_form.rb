class Conversion::Task::ConfirmDateAcademyOpenedTaskForm < BaseTaskForm
  attribute :date_opened, :date
  attribute "date_opened(1i)"
  attribute "date_opened(2i)"
  attribute "date_opened(3i)"

  validate :govuk_three_field_date_format

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_opened = @project.tasks_data.confirm_date_academy_opened_date_opened
  end

  def save
    if valid?
      @tasks_data.assign_attributes(
        confirm_date_academy_opened_date_opened: formatted_date
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
    errors.add(:date_opened, I18n.t("conversion.task.confirm_date_academy_opened.errors.format"))
  end

  private def day
    day = attributes["date_opened(3i)"]
    return if day.blank?

    day.to_i
  end

  private def month
    month = attributes["date_opened(2i)"]
    return if month.blank?

    month.to_i
  end

  private def year
    year = attributes["date_opened(1i)"]
    return false unless ("1900".."3000").to_a.include?(year)
    return if year.blank?

    year.to_i
  end

  def completed?
    date_opened.present?
  end
end
