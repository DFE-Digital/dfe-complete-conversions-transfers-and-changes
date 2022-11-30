class Conversion::Project < Project
  has_one :details, class_name: "Conversion::Details", dependent: :destroy

  def self.policy_class
    ProjectPolicy
  end
end
