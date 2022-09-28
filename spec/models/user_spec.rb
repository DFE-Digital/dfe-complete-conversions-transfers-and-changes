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
    let!(:caseworker) { create(:user, :caseworker) }
    let!(:caseworker_2) { create(:user, :caseworker, first_name: "Aaron", email: "aaron-caseworker@education.gov.uk") }
    let!(:team_leader) { create(:user, :team_leader) }
    let!(:team_leader_2) { create(:user, :team_leader, first_name: "Andy", email: "aaron-team-leader@education.gov.uk") }
    let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
    let!(:regional_delivery_officer_2) { create(:user, :regional_delivery_officer, first_name: "Adam", email: "aaron-rdo@education.gov.uk") }

    describe "order_by_first_name" do
      it "orders by first_name" do
        expect(User.order_by_first_name.count).to be 6
        expect(User.order_by_first_name.first).to eq caseworker_2
        expect(User.order_by_first_name.last).to eq team_leader
      end
    end

    describe "team_leaders" do
      it "only includes users that have the team leader role sorted by first_name" do
        expect(User.team_leaders.count).to be 2
        expect(User.team_leaders.first).to eq team_leader_2
        expect(User.team_leaders.last).to eq team_leader
      end
    end

    describe "regional_delivery_officers" do
      it "only includes users that have the regional delivery officer role sorted by first_name" do
        expect(User.regional_delivery_officers.count).to be 2
        expect(User.regional_delivery_officers.first).to eq regional_delivery_officer_2
        expect(User.regional_delivery_officers.last).to eq regional_delivery_officer
      end
    end

    describe "caseworkers" do
      it "only includes users that have the caseworker role sorted by first_name" do
        expect(User.caseworkers.count).to be 2
        expect(User.caseworkers.first).to eq caseworker_2
        expect(User.caseworkers.last).to eq caseworker
      end
    end
  end

  describe "Validations" do
    describe "#first_name" do
      it { is_expected.to validate_presence_of(:first_name) }
    end

    describe "#last_name" do
      it { is_expected.to validate_presence_of(:first_name) }
    end
  end

  describe "#full_name" do
    let(:user) { build(:user) }

    subject { user.full_name }

    it "returns full name" do
      expect(subject).to eq "John Doe"
    end
  end
end
