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
        Conversion::Involuntary::Tasks::Subleases,
        Conversion::Involuntary::Tasks::LandQuestionnaire,
        Conversion::Involuntary::Tasks::LandRegistry
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
