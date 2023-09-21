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
          Transfer::Task::FormMTaskForm,
          Transfer::Task::LandConsentLetterTaskForm,
          Transfer::Task::SupplementalFundingAgreementTaskForm,
          Transfer::Task::DeedOfNovationAndVariationTaskForm,
          Transfer::Task::ChurchSupplementalAgreementTaskForm,
          Transfer::Task::MasterFundingAgreementTaskForm,
          Transfer::Task::ArticlesOfAssociationTaskForm,
          Transfer::Task::DeedOfVariationTaskForm,
          Transfer::Task::DeedOfTerminationForTheMasterFundingAgreementTaskForm,
          Transfer::Task::DeedTerminationChurchAgreementTaskForm,
          Transfer::Task::CommercialTransferAgreementTaskForm,
          Transfer::Task::ClosureOrTransferDeclarationTaskForm
        ]
      },
      {
        identifier: :get_ready_for_opening,
        tasks: [
          Transfer::Task::ConditionsMetTaskForm,
          Transfer::Task::ConfirmIncomingTrustHasCompletedAllActionsTaskForm,
          Transfer::Task::RpaPolicyTaskForm
        ]
      },
      {
        identifier: :after_transfer,
        tasks: [
          Transfer::Task::RedactAndSendDocumentsTaskForm
        ]
      }
    ]
  end
end
