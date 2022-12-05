class Conversion::Project < Project
  has_one :details, class_name: "Conversion::Details", dependent: :destroy
  has_one :task_list, class_name: "Conversion::Volunatary::TaskList", dependent: :destroy

  def self.policy_class
    ProjectPolicy
  end
end
