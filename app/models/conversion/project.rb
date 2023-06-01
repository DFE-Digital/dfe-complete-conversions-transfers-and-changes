class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

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
end
