class Conversion::Voluntary::TaskList < TaskList::Base
  self.table_name = "conversion_voluntary_task_lists"

  TASK_LIST_LAYOUT = [
    {
      identifier: :project_kick_off,
      tasks: [
        Conversion::Voluntary::Tasks::Handover,
        Conversion::Voluntary::Tasks::StakeholderKickOff
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
