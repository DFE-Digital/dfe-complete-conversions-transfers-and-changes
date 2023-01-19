class Conversion::Project < Project
  has_one :details, class_name: "Conversion::Details", dependent: :destroy

  def self.policy_class
    ProjectPolicy
  end

  def route
    return :voluntary if task_list_type == "Conversion::Voluntary::TaskList"
    return :involuntary if task_list_type == "Conversion::Involuntary::TaskList"
  end
end
