class Transfer::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: [
          Transfer::Task::HandoverTaskForm,
          Transfer::Task::StakeholderKickOffTaskForm,
          Transfer::Task::MainContactTaskForm
        ]
      },
      {
        identifier: :legal_documents,
        tasks: [
          Transfer::Task::MasterFundingAgreementTaskForm,
          Transfer::Task::DeedOfNovationAndVariationTaskForm,
          Transfer::Task::ArticlesOfAssociationTaskForm,
          Transfer::Task::CommercialTransferAgreementTaskForm,
          Transfer::Task::DeedOfVariationTaskForm,
          Transfer::Task::SupplementalFundingAgreementTaskForm,
          Transfer::Task::LandConsentLetterTaskForm,
          Transfer::Task::FormMTaskForm,
          Transfer::Task::ChurchSupplementalAgreementTaskForm,
          Transfer::Task::DeedOfTerminationForTheMasterFundingAgreementTaskForm,
          Transfer::Task::DeedTerminationChurchAgreementTaskForm
        ]
      },
      {
        identifier: :get_ready_for_opening,
        tasks: [
          Transfer::Task::ConditionsMetTaskForm,
          Transfer::Task::RpaPolicyTaskForm
        ]
      }
    ]
  end
end
