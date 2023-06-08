class Transfer::TasksData < ActiveRecord::Base
  include TasksDatable

  def self.policy_class
    TaskListPolicy
  end
end
