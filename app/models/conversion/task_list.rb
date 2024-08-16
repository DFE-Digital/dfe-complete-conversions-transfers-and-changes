class Conversion::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: [
          Conversion::Task::HandoverTaskForm,
          Conversion::Task::StakeholderKickOffTaskForm,
          Conversion::Task::CheckAccuracyOfHigherNeedsTaskForm,
          Conversion::Task::CompleteNotificationOfChangeTaskForm,
          Conversion::Task::ConversionGrantTaskForm,
          Conversion::Task::SponsoredSupportGrantTaskForm,
          Conversion::Task::AcademyDetailsTaskForm,
          Conversion::Task::ConfirmHeadteacherContactTaskForm,
          Conversion::Task::ConfirmChairOfGovernorsContactTaskForm,
          Conversion::Task::ConfirmIncomingTrustCeoContactTaskForm,
          Conversion::Task::MainContactTaskForm,
          Conversion::Task::ProposedCapacityOfTheAcademyTaskForm
        ]
      },
      {
        identifier: :legal_documents,
        tasks: [
          Conversion::Task::LandQuestionnaireTaskForm,
          Conversion::Task::LandRegistryTaskForm,
          Conversion::Task::SupplementalFundingAgreementTaskForm,
          Conversion::Task::ChurchSupplementalAgreementTaskForm,
          Conversion::Task::MasterFundingAgreementTaskForm,
          Conversion::Task::ArticlesOfAssociationTaskForm,
          Conversion::Task::DeedOfVariationTaskForm,
          Conversion::Task::TrustModificationOrderTaskForm,
          Conversion::Task::DirectionToTransferTaskForm,
          Conversion::Task::OneHundredAndTwentyFiveYearLeaseTaskForm,
          Conversion::Task::SubleasesTaskForm,
          Conversion::Task::TenancyAtWillTaskForm,
          Conversion::Task::CommercialTransferAgreementTaskForm
        ]
      },
      {
        identifier: :get_ready_for_opening,
        tasks: [
          Conversion::Task::RiskProtectionArrangementTaskForm,
          Conversion::Task::SingleWorksheetTaskForm,
          Conversion::Task::SchoolCompletedTaskForm,
          Conversion::Task::ConditionsMetTaskForm,
          Conversion::Task::ShareInformationTaskForm
        ]
      },
      {
        identifier: :after_opening,
        tasks: [
          Conversion::Task::ConfirmDateAcademyOpenedTaskForm,
          Conversion::Task::RedactAndSendTaskForm,
          Conversion::Task::ReceiveGrantPaymentCertificateTaskForm
        ]
      }
    ]
  end
end
