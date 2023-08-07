class Transfer::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: [
          Transfer::Task::StakeholderKickOffTaskForm
        ]
      },
      {
        identifier: :get_ready_for_opening,
        tasks: [
          Transfer::Task::ConditionsMetTaskForm
        ]
      }
    ]
  end
end
