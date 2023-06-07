class Transfer::Project < Project
  def self.policy_class
    ProjectPolicy
  end
end
