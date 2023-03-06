require "rails_helper"

RSpec.describe ProjectPolicy do
  describe "#change_conversion_date?" do
    context "when the conversion date is provisional" do
      it "returns false" do
        project = build(:conversion_project)
        user = build(:user, :caseworker)

        policy = described_class.new(user, project)

        expect(policy.change_conversion_date?).to eq false
      end
    end

    context "when the conversion date is confirmed" do
      it "returns true" do
        project = build(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
        user = build(:user, :caseworker)

        policy = described_class.new(user, project)

        expect(policy.change_conversion_date?).to eq true
      end
    end
  end
end
