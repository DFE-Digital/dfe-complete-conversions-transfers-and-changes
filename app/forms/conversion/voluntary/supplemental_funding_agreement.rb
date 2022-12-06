module Conversion
  module Voluntary
    class SupplementalFundingAgreement < TaskListTask
      attribute :received
      attribute :cleared
      attribute :signed_by_school
      attribute :saved_in_school_sharepoint
      attribute :sent_to_team_leader
      attribute :document_signed

      def self.compose(
        received,
        cleared,
        signed_by_school,
        saved_in_school_sharepoint,
        sent_to_team_leader,
        document_signed
      )
        new(
          received:,
          cleared:,
          signed_by_school:,
          saved_in_school_sharepoint:,
          sent_to_team_leader:,
          document_signed:
        )
      end
    end
  end
end
