class Conversion::TasksData < ActiveRecord::Base
  include TasksDatable

  self.table_name = "conversion_tasks_data"

  def self.policy_class
    TaskListPolicy
  end
end
