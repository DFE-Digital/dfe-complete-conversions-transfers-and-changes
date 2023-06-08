class Transfer::TasksData < ActiveRecord::Base
  include TasksDatable

  self.table_name = "transfer_tasks_data"

  def self.policy_class
    TaskListPolicy
  end
end
