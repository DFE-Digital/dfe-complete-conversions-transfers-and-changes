class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  has_many :conversion_dates, dependent: :destroy, class_name: "Conversion::DateHistory"

  def route
    return :sponsored if directive_academy_order?
    :voluntary
  end
end
