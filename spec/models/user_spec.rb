require "rails_helper"

RSpec.describe User do
  describe "Columns" do
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:first_name).of_type :string }
    it { is_expected.to have_db_column(:last_name).of_type :string }
    it { is_expected.to have_db_column(:team_leader).of_type :boolean }
    it { is_expected.to have_db_column(:regional_delivery_officer).of_type :boolean }
    it { is_expected.to have_db_column(:caseworker).of_type :boolean }
  end

  describe "scopes" do
    describe "caseworkers" do
      let!(:caseworker) { create(:user, :caseworker) }
      let!(:team_lead) { create(:user, :team_leader) }
      let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }

      it "only includes users that have the caseworker role" do
        expect(User.caseworkers.count).to be 1
        expect(User.caseworkers).to include caseworker
      end
    end
  end

  describe "#full_name" do
    subject { user.full_name }

    context "when first name is nil" do
      let(:user) { build(:user, first_name: nil) }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "when last name is nil" do
      let(:user) { build(:user, last_name: nil) }

      it "returns nil" do
        expect(subject).to be_nil
      end
    end

    context "when first name and last name are present" do
      let(:user) { build(:user) }

      it "returns full name" do
        expect(subject).to eq "John Doe"
      end
    end
  end
end
