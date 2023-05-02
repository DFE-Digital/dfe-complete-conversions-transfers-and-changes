class Conversion::TaskList < ::BaseTaskList
  def self.layout
    [
      identifier: :project_kick_off,
      tasks: [
        Conversion::Task::StakeholderKickOffTaskForm,
        Conversion::Task::FundingAgreementContactTaskForm,
        Conversion::Task::RedactAndSendTaskForm
      ]
    ]
  end
end
