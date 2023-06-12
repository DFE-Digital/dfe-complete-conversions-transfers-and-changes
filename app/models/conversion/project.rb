class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  validates :academy_urn, urn: true, if: -> { academy_urn.present? }

  scope :no_academy_urn, -> { where(academy_urn: nil) }
  scope :with_academy_urn, -> { where.not(academy_urn: nil) }

  has_many :conversion_dates, dependent: :destroy, class_name: "Conversion::DateHistory"

  def route
    return :sponsored if directive_academy_order?
    :voluntary
  end

  def fetch_provisional_conversion_date
    return conversion_date if conversion_dates.empty?

    conversion_dates.order(:created_at).first.previous_date
  end

  def all_conditions_met?
    tasks_data.conditions_met_confirm_all_conditions_met?
  end

  def conversion_date_confirmed_and_passed?
    !conversion_date_provisional? && conversion_date.past?
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

  private def fetch_academy(urn)
    Api::AcademiesApi::Client.new.get_establishment(urn)
  end
end
