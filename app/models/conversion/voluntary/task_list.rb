class Conversion::Voluntary::TaskList < TaskList::Base
  self.table_name = "conversion_voluntary_task_lists"

  def self.policy_class
    TaskListPolicy
  end

  TASK_LIST_LAYOUT = [].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
