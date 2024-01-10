class Conversion::Task::ReceiveGrantPaymentCertificateTaskForm < BaseTaskForm
  attribute :check_certificate, :boolean
  attribute :save_certificate, :boolean
  attribute "date_received(1i)"
  attribute "date_received(2i)"
  attribute "date_received(3i)"
  attribute :date_received, :date

  validate :date_format

  def initialize(tasks_data, user)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_received = @project.tasks_data.receive_grant_payment_certificate_date_received
  end

  def save
    @tasks_data.assign_attributes(
      receive_grant_payment_certificate_date_received: formatted_date_received,
      receive_grant_payment_certificate_check_certificate: check_certificate,
      receive_grant_payment_certificate_save_certificate: save_certificate
    )
    @tasks_data.save!
  end

  def formatted_date_received
    return @project.tasks_data.receive_grant_payment_certificate_date_received if @project.tasks_data.receive_grant_payment_certificate_date_received.present?
    return nil if month.blank? || year.blank? || day.blank?
    Date.new(year, month, day)
  end

  private def date_format
    return if month.blank? && year.blank? && day.blank?

    Date.new(year, month, day)
  rescue TypeError, Date::Error
    errors.add(:date_received, I18n.t("conversion.task.receive_grant_payment_certificate.date_received.errors.format"))
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
    return if year.blank?

    year.to_i
  end

  def completed?
    attributes.except(
      "date_received(3i)",
      "date_received(2i)",
      "date_received(1i)"
    ).values.all?(&:present?)
  end

  def in_progress?
    attributes.except(
      "date_received(3i)",
      "date_received(2i)",
      "date_received(1i)"
    ).values.any?(&:present?)
  end
end
