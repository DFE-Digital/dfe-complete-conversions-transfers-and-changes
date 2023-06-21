require "rails_helper"

RSpec.describe User do
  describe "Columns" do
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:first_name).of_type :string }
    it { is_expected.to have_db_column(:last_name).of_type :string }
    it { is_expected.to have_db_column(:team_leader).of_type :boolean }
    it { is_expected.to have_db_column(:regional_delivery_officer).of_type :boolean }
    it { is_expected.to have_db_column(:caseworker).of_type :boolean }
    it { is_expected.to have_db_column(:service_support).of_type :boolean }
    it { is_expected.to have_db_column(:active_directory_user_group_ids).of_type :string }
  end

  describe "scopes" do
    let!(:caseworker) { create(:user, :caseworker) }
    let!(:caseworker_2) { create(:user, :caseworker, first_name: "Aaron", email: "aaron-caseworker@education.gov.uk") }
    let!(:team_leader) { create(:user, :team_leader) }
    let!(:team_leader_2) { create(:user, :team_leader, first_name: "Andy", email: "aaron-team-leader@education.gov.uk") }
    let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
    let!(:regional_delivery_officer_2) { create(:user, :regional_delivery_officer, first_name: "Adam", email: "aaron-rdo@education.gov.uk") }
    let!(:user_without_role) { create(:user, caseworker: false, team_leader: false, regional_delivery_officer: false) }

    describe "order_by_first_name" do
      it "orders by first_name" do
        expect(User.order_by_first_name.count).to be 7
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

    describe "all_assignable_users" do
      it "only includes users who have a role" do
        expect(User.all_assignable_users.count).to eq 6
        expect(User.all_assignable_users).to_not include(user_without_role)
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

  describe "#has_role?" do
    it "returns true when the user has one of the set roles" do
      caseworker_user = create(:user, :caseworker)
      regional_delivery_officer_user = create(:user, :regional_delivery_officer)
      team_lead_user = create(:user, :team_leader)

      expect(caseworker_user.has_role?).to be true
      expect(regional_delivery_officer_user.has_role?).to be true
      expect(team_lead_user.has_role?).to be true
    end

    it "returns false when the user has no set role" do
      user = create(:user)

      expect(user.has_role?).to be false
    end
  end
end
