class Conversion::Task::ReceiveGrantPaymentCertificateTaskForm < BaseTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :check_certificate, :boolean
  attribute :save_certificate, :boolean
  attribute :date_received, :date

  def initialize(tasks_data, user)
    @date_param_errors = ActiveModel::Errors.new(self)
    @tasks_data = tasks_data
    @user = user
    @project = tasks_data.project
    super(@tasks_data, @user)

    self.date_received = @project.tasks_data.receive_grant_payment_certificate_date_received
  end

  def assign_attributes(attributes)
    if GovukDateFieldParameters.new(:date_received, attributes).invalid?
      @date_param_errors.add(:date_received, I18n.t("conversion.task.receive_grant_payment_certificate.date_received.errors.invalid"))

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

  def save
    @tasks_data.assign_attributes(
      receive_grant_payment_certificate_date_received: date_received,
      receive_grant_payment_certificate_check_certificate: check_certificate,
      receive_grant_payment_certificate_save_certificate: save_certificate
    )
    @tasks_data.save!
  end
end
