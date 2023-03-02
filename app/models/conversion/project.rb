class Conversion::Project < Project
  def self.policy_class
    ProjectPolicy
  end

  has_many :conversion_dates, dependent: :destroy, class_name: "Conversion::DateHistory"

  def route
    return :voluntary if task_list_type == "Conversion::Voluntary::TaskList"
    return :involuntary if task_list_type == "Conversion::Involuntary::TaskList"
  end
end
