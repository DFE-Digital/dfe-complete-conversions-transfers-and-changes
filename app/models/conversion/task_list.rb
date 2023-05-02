class Conversion::TaskList < ::BaseTaskList
  def self.layout
    [
      {
        identifier: :project_kick_off,
        tasks: [
          Conversion::Task::HandoverTaskForm,
          Conversion::Task::StakeholderKickOffTaskForm,
          Conversion::Task::ConversionGrantTaskForm,
          Conversion::Task::SponsoredSupportGrantTaskForm,
          Conversion::Task::FundingAgreementContactTaskForm
        ]
      },
      {
        identifier: :legal_documents,
        tasks: [
          Conversion::Task::LandQuestionnaireTaskForm,
          Conversion::Task::LandRegistryTaskForm,
          Conversion::Task::SupplementalFundingAgreementTaskForm,
          Conversion::Task::ArticlesOfAssociationTaskForm
        ]
      },
      {
        identifier: :get_ready_for_opening,
        tasks: []
      },
      {
        identifier: :after_opening,
        tasks: [
          Conversion::Task::RedactAndSendTaskForm
        ]
      }
    ]
  end
end
