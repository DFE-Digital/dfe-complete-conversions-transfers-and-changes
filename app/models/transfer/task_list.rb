class Transfer::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: [
          Transfer::Task::HandoverTaskForm,
          Transfer::Task::StakeholderKickOffTaskForm
        ]
      },
      {
        identifier: :legal_documents,
        tasks: [
          Transfer::Task::MasterFundingAgreementTaskForm,
          Transfer::Task::DeedOfNovationAndVariationTaskForm,
          Transfer::Task::ArticlesOfAssociationTaskForm,
          Transfer::Task::CommercialTransferAgreementTaskForm
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
