class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  attr_writer :academy

  alias_attribute :conversion_date, :significant_date
  alias_attribute :conversion_date_provisional, :significant_date_provisional

  validates :academy_urn, urn: true, if: -> { academy_urn.present? }
  validate :school_and_academy_urn_must_not_match
  validates :directive_academy_order, inclusion: {in: [true, false]}
  validates :two_requires_improvement, inclusion: {in: [true, false]}
  validates :conversion_date, presence: true
  validates :conversion_date, first_day_of_month: true

  scope :no_academy_urn, -> { where(academy_urn: nil) }
  scope :with_academy_urn, -> { where.not(academy_urn: nil) }
  scope :by_conversion_date, -> { ordered_by_significant_date }

  MANDATORY_CONDITIONS = [
    :all_conditions_met?,
    :confirmed_date_and_in_the_past?,
    :grant_payment_certificate_received?,
    :date_academy_opened_present?
  ]

  def grant_payment_certificate_received?
    user = assigned_to
    tasks = Conversion::Task::ReceiveGrantPaymentCertificateTaskForm.new(tasks_data, user)
    return true if tasks.status.eql?(:completed)
    false
  end

  def academy
    @academy ||= fetch_academy(academy_urn)
  end

  def academy_found?
    academy.present?
  end

  def academy_order_type
    return :directive_academy_order if directive_academy_order?
    :academy_order
  end

  def completable?
    MANDATORY_CONDITIONS.all? { |task| send(task) }
  end

  def date_academy_opened_present?
    return true if tasks_data.confirm_date_academy_opened_date_opened.present?
    false
  end

  private def fetch_academy(urn)
    Gias::Establishment.find_by(urn: urn)
  end

  private def school_and_academy_urn_must_not_match
    errors.add(:academy_urn, :matching_school_urn) if urn == academy_urn
  end
end
