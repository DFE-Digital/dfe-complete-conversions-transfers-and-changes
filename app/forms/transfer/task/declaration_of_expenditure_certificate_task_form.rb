class Transfer::Task::DeclarationOfExpenditureCertificateTaskForm < BaseOptionalTaskForm
  attribute :date_received, :date
  attribute :correct, :boolean
  attribute :saved, :boolean
  attribute "date_received(1i)"
  attribute "date_received(2i)"
  attribute "date_received(3i)"

  validate :govuk_three_field_date_format

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_received = @project.tasks_data.declaration_of_expenditure_certificate_date_received
  end

  def save
    if valid?
      @tasks_data.assign_attributes(
        declaration_of_expenditure_certificate_date_received: formatted_date,
        declaration_of_expenditure_certificate_not_applicable: not_applicable,
        declaration_of_expenditure_certificate_correct: correct,
        declaration_of_expenditure_certificate_saved: saved
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
    errors.add(:date_received, I18n.t("transfer.task.confirm_date_academy_transferred.errors.format"))
  end

  private def day
    day = attributes["date_received(3i)"]
    return if day.blank?

    day.to_i
  end

  private def month
    month = attributes["date_received(2i)"]
    return if month.blank?

    month.to_i
  end

  private def year
    year = attributes["date_received(1i)"]
    return false unless ("1900".."3000").to_a.include?(year)
    return if year.blank?

    year.to_i
  end

  def completed?
    date_received.present? && correct.present? && saved.present?
  end
end
