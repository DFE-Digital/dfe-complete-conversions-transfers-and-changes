require "rails_helper"

RSpec.describe UserHelper, type: :helper do
  describe "#last_seen_datetime" do
    context "with an active user" do
      it "shows the formatted latest_session date" do
        user = build(:user, latest_session: DateTime.new(2023, 1, 1, 10, 30, 0, 0))
        expect(helper.last_seen_datetime(user)).to eq("1 January 2023 10:30am")
      end
    end

    context "with an inactive user" do
      it "shows not applicable" do
        user = build(:user, latest_session: DateTime.new(2023, 1, 1, 10, 30, 0, 0), deactivated_at: DateTime.now)
        expect(helper.last_seen_datetime(user)).to eq("N/A")
      end
    end

    context "with an active user who has never logged in" do
      it "shows not applicable" do
        user = build(:user, latest_session: nil)
        expect(helper.last_seen_datetime(user)).to eq("N/A")
      end
    end
  end
end
