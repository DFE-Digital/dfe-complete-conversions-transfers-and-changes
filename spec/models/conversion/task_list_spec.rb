require "rails_helper"

RSpec.describe Conversion::TaskList do
  let(:user) { create(:user) }

  describe ".identifiers" do
    it "returns all the identifiers for the tasks in the list" do
      converison_task_list_identifiers = [
        :handover,
        :stakeholder_kick_off,
        :check_accuracy_of_higher_needs,
        :complete_notification_of_change,
        :conversion_grant,
        :sponsored_support_grant,
        :academy_details,
        :confirm_headteacher_contact,
        :confirm_chair_of_governors_contact,
        :confirm_incoming_trust_ceo_contact,
        :main_contact,
        :proposed_capacity_of_the_academy,
        :land_questionnaire,
        :land_registry,
        :supplemental_funding_agreement,
        :church_supplemental_agreement,
        :master_funding_agreement,
        :articles_of_association,
        :deed_of_variation,
        :trust_modification_order,
        :direction_to_transfer,
        :one_hundred_and_twenty_five_year_lease,
        :subleases,
        :tenancy_at_will,
        :commercial_transfer_agreement,
        :risk_protection_arrangement,
        :single_worksheet,
        :school_completed,
        :conditions_met,
        :share_information,
        :confirm_date_academy_opened,
        :redact_and_send,
        :receive_grant_payment_certificate
      ]

      expect(described_class.identifiers).to eql converison_task_list_identifiers
    end
  end

  describe ".layout" do
    it "returns the layout hash for the task list" do
      conversion_task_list_layout =
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
      expect(described_class.layout).to eql conversion_task_list_layout
    end
  end

  describe "#sections" do
    it "returns an array of the sections in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)
      task_list = described_class.new(project, user)

      expect(task_list.sections.count).to eql 4
    end
  end

  describe "#tasks" do
    it "returns an array of all the tasks in the task list" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)
      task_list = described_class.new(project, user)

      expect(task_list.tasks.count).to eql 33
      expect(task_list.tasks.first).to be_a Conversion::Task::HandoverTaskForm
      expect(task_list.tasks.last).to be_a Conversion::Task::ReceiveGrantPaymentCertificateTaskForm
    end
  end
end
