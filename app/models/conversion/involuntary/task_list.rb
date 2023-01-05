class Conversion::Involuntary::TaskList < TaskList::Base
  self.table_name = "conversion_involuntary_task_lists"

  TASK_LIST_LAYOUT = [
    {
      identifier: :project_kick_off,
      tasks: [
        Conversion::Involuntary::Tasks::Handover,
        Conversion::Involuntary::Tasks::StakeholderKickOff,
        Conversion::Involuntary::Tasks::ConversionGrant
      ]
    },
    {
      identifier: :legal_documents,
      tasks: [
        Conversion::Involuntary::Tasks::LandQuestionnaire,
        Conversion::Involuntary::Tasks::LandRegistry,
        Conversion::Involuntary::Tasks::SupplementalFundingAgreement,
        Conversion::Involuntary::Tasks::ChurchSupplementalAgreement,
        Conversion::Involuntary::Tasks::MasterFundingAgreement,
        Conversion::Involuntary::Tasks::ArticlesOfAssociation,
        Conversion::Involuntary::Tasks::DeedOfVariation,
        Conversion::Involuntary::Tasks::TrustModificationOrder,
        Conversion::Involuntary::Tasks::DirectionToTransfer,
        Conversion::Involuntary::Tasks::OneHundredAndTwentyFiveYearLease,
        Conversion::Involuntary::Tasks::Subleases,
        Conversion::Involuntary::Tasks::TenancyAtWill,
        Conversion::Involuntary::Tasks::CommercialTransferAgreement
      ]
    },
    {
      identifier: :get_ready_for_opening,
      tasks: [
        Conversion::Involuntary::Tasks::CheckBaseline,
        Conversion::Involuntary::Tasks::SingleWorksheet,
        Conversion::Involuntary::Tasks::SchoolCompleted,
        Conversion::Involuntary::Tasks::ConditionsMet
      ]
    },
    {
      identifier: :after_opening,
      tasks: [
        Conversion::Involuntary::Tasks::TellRegionalDeliveryOfficer,
        Conversion::Involuntary::Tasks::ShareInformation,
        Conversion::Involuntary::Tasks::RedactAndSend,
        Conversion::Involuntary::Tasks::UpdateEsfa
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
