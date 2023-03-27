class Conversion::Voluntary::TaskList < TaskList::Base
  self.table_name = "conversion_voluntary_task_lists"

  def self.policy_class
    TaskListPolicy
  end

  after_save :set_conversion_date

  def set_conversion_date
    return if project.nil?
    return unless project.conversion_date_provisional?

    raise TaskListUserError.new("You must set the `user` attribute on #{self}") if user.nil?

    revised_date = stakeholder_kick_off_confirmed_conversion_date
    note_body = I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.confirmed_conversion_date.note")

    ConversionDateUpdater.new(project: project, revised_date: revised_date, note_body: note_body, user: user).update!
  end

  TASK_LIST_LAYOUT = [
    {
      identifier: :project_kick_off,
      tasks: [
        Conversion::Voluntary::Tasks::Handover,
        Conversion::Voluntary::Tasks::StakeholderKickOff,
        Conversion::Voluntary::Tasks::ConversionGrant,
        Conversion::Voluntary::Tasks::SponsoredSupportGrant
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
        Conversion::Voluntary::Tasks::DirectionToTransfer,
        Conversion::Voluntary::Tasks::OneHundredAndTwentyFiveYearLease,
        Conversion::Voluntary::Tasks::Subleases,
        Conversion::Voluntary::Tasks::TenancyAtWill,
        Conversion::Voluntary::Tasks::CommercialTransferAgreement
      ]
    },
    {
      identifier: :get_ready_for_opening,
      tasks: [
        Conversion::Voluntary::Tasks::SingleWorksheet,
        Conversion::Voluntary::Tasks::SchoolCompleted,
        Conversion::Voluntary::Tasks::ConditionsMet,
        Conversion::Voluntary::Tasks::ShareInformation
      ]
    },
    {
      identifier: :after_opening,
      tasks: [
        Conversion::Voluntary::Tasks::TellRegionalDeliveryOfficer,
        Conversion::Voluntary::Tasks::RedactAndSend,
        Conversion::Voluntary::Tasks::UpdateEsfa,
        Conversion::Voluntary::Tasks::ReceiveGrantPaymentCertificate
      ]
    }
  ].freeze

  def task_list_layout
    TASK_LIST_LAYOUT
  end
end
