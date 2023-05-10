class Conversion::TasksData < ActiveRecord::Base
  include TasksDatable

  self.table_name = "conversion_voluntary_task_lists"

  def self.policy_class
    TaskListPolicy
  end
end
