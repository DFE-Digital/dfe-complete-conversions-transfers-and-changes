class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  validates :academy_urn, urn: true, if: -> { academy_urn.present? }
  validates :conversion_date, presence: true
  validates :conversion_date, first_day_of_month: true
  validates :directive_academy_order, inclusion: {in: [true, false]}

  scope :no_academy_urn, -> { where(academy_urn: nil) }
  scope :with_academy_urn, -> { where.not(academy_urn: nil) }

  scope :provisional, -> { where(conversion_date_provisional: true) }
  scope :confirmed, -> { where(conversion_date_provisional: false) }
  scope :opening_by_month_year, ->(month, year) { where(conversion_date_provisional: false).and(where("YEAR(conversion_date) = ?", year)).and(where("MONTH(conversion_date) = ?", month)) }
  scope :by_conversion_date, -> { order(conversion_date: :asc) }
  scope :in_progress, -> { where(completed_at: nil).assigned.by_conversion_date }

  scope :sponsored, -> { where(directive_academy_order: true) }
  scope :voluntary, -> { where(directive_academy_order: false) }

  has_many :conversion_dates, dependent: :destroy, class_name: "Conversion::DateHistory"

  def self.conversion_date_revised_from(month, year)
    projects = Conversion::Project.in_progress.confirmed

    latest_date_histories = Conversion::DateHistory.group(:project_id).having("COUNT(created_at) > 1").maximum(:created_at)

    matching_date_histories = Conversion::DateHistory
      .where(project_id: latest_date_histories.keys)
      .where(created_at: latest_date_histories.values)
      .to_sql

    projects.joins("INNER JOIN (#{matching_date_histories}) AS date_history ON date_history.project_id = projects.id")
      .where("date_history.previous_date != date_history.revised_date")
      .where("MONTH(date_history.previous_date) = ?", month)
      .where("YEAR(date_history.previous_date) = ?", year)
      .by_conversion_date
  end

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
