require "rails_helper"

RSpec.describe DaoRevocationReason do
  describe "attributes" do
    it do
      should define_enum_for(:reason_type)
        .with_values(
          reason_school_closed: "school_closed",
          reason_school_rating_improved: "school_rating_improved",
          reason_safeguarding_addressed: "safeguarding_addressed",
          reason_change_to_policy: "change_to_policy"
        )
        .backed_by_column_of_type(:string)
    end
  end

  describe "associations" do
    it { should belong_to(:dao_revocation) }
    it { should have_one(:note) }
  end

  describe "validations" do
    it { should validate_presence_of(:reason_type) }
    it { should validate_presence_of(:note) }
  end
end
