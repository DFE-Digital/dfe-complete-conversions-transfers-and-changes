module Conversion
  module Voluntary
    class LandQuestionnaire < TaskListTask
      attribute :received
      attribute :cleared
      attribute :signed_by_solicitor
      attribute :saved_in_school_sharepoint

      def self.compose(
        received,
        cleared,
        signed_by_solicitor,
        saved_in_school_sharepoint
      )
        new(
          received:,
          cleared:,
          signed_by_solicitor:,
          saved_in_school_sharepoint:
        )
      end
    end
  end
end
