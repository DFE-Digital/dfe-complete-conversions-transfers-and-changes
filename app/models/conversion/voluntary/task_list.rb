class Conversion::Voluntary::TaskList < TaskList::Base
  self.table_name = "conversion_voluntary_task_lists"

  TASK_LIST_LAYOUT = [
    {
      identifier: :project_kick_off,
      tasks: [
        Conversion::Voluntary::Tasks::Handover,
        Conversion::Voluntary::Tasks::StakeholderKickOff,
        Conversion::Voluntary::Tasks::ConversionGrant
      ]
    },
    {
      identifier: :legal_documents,
      tasks: [
        Conversion::Voluntary::Tasks::LandQuestionnaire,
        Conversion::Voluntary::Tasks::LandRegistry,
        Conversion::Voluntary::Tasks::SupplementalFundingAgreement,
        Conversion::Voluntary::Tasks::ChurchSupplementalAgreement,
        Conversion::Voluntary::Tasks::MasterFundingAgreement,
        Conversion::Voluntary::Tasks::ArticlesOfAssociation,
        Conversion::Voluntary::Tasks::DeedOfVariation,
        Conversion::Voluntary::Tasks::TrustModificationOrder,
        Conversion::Voluntary::Tasks::DirectionToTransfer
      ]
    },
    {
      identifier: :get_ready_for_opening,
      tasks: [
        Conversion::Voluntary::Tasks::CheckBaseline,
        Conversion::Voluntary::Tasks::SingleWorksheet,
        Conversion::Voluntary::Tasks::SchoolCompleted,
        Conversion::Voluntary::Tasks::ConditionsMet
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
