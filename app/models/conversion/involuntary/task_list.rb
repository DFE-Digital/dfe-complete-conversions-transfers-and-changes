class Conversion::Involuntary::TaskList < TaskList::Base
  self.table_name = "conversion_involuntary_task_lists"

  TASK_LIST_LAYOUT = [
    {
      identifier: :project_kick_off,
      tasks: [
        Conversion::Involuntary::Tasks::Handover
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
