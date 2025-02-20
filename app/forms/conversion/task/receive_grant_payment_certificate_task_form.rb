class Conversion::Task::ReceiveGrantPaymentCertificateTaskForm < BaseOptionalTaskForm
  include ActiveRecord::AttributeAssignment

  attribute :check_certificate, :boolean
  attribute :save_certificate, :boolean
  attribute :date_received, :date
  attribute :not_applicable

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
    if not_applicable
      assign_not_applicable_response
    else
      assign_applicable_responses
    end

    @tasks_data.save!
  end

  private def assign_applicable_responses
    @tasks_data.assign_attributes(
      receive_grant_payment_certificate_date_received: date_received,
      receive_grant_payment_certificate_check_certificate: check_certificate,
      receive_grant_payment_certificate_save_certificate: save_certificate
    )
  end

  private def assign_not_applicable_response
    @tasks_data.assign_attributes(
      receive_grant_payment_certificate_not_applicable: not_applicable
    )
  end
end
