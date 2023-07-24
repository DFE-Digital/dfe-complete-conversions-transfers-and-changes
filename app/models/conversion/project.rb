class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  attr_writer :academy

  validates :academy_urn, urn: true, if: -> { academy_urn.present? }
  validates :directive_academy_order, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false]}

  scope :no_academy_urn, -> { where(academy_urn: nil) }
  scope :with_academy_urn, -> { where.not(academy_urn: nil) }
  scope :by_conversion_date, -> { ordered_by_significant_date }

  scope :sponsored, -> { where(directive_academy_order: true) }
  scope :voluntary, -> { where(directive_academy_order: false) }

  def route
    return :sponsored if directive_academy_order?
    :voluntary
  end

  def all_conditions_met?
    tasks_data.conditions_met_confirm_all_conditions_met?
  end

  def grant_payment_certificate_received?
    user = assigned_to
    tasks = Conversion::Task::ReceiveGrantPaymentCertificateTaskForm.new(tasks_data, user)
    return true if tasks.status.eql?(:completed)
    false
  end

  def academy
    @academy ||= fetch_academy(academy_urn).object
  end

  def academy_found?
    academy.present?
  end

  def academy_order_type
    return :directive_academy_order if directive_academy_order?
    :academy_order
  end

  private def fetch_academy(urn)
    Api::AcademiesApi::Client.new.get_establishment(urn)
  end
end
