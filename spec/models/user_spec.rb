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
    it { is_expected.to have_db_column(:team).of_type :string }
    it { is_expected.to have_db_column(:deactivated_at).of_type :datetime }
  end

  describe "scopes" do
    let!(:caseworker) { create(:user, :caseworker) }
    let!(:caseworker_2) { create(:user, :caseworker, first_name: "Aaron", email: "aaron-caseworker@education.gov.uk") }
    let!(:team_leader) { create(:user, :team_leader) }
    let!(:team_leader_2) { create(:user, :team_leader, first_name: "Andy", email: "aaron-team-leader@education.gov.uk") }
    let!(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
    let!(:regional_delivery_officer_2) { create(:user, :regional_delivery_officer, first_name: "Adam", email: "aaron-rdo@education.gov.uk") }
    let!(:user_without_role) { create(:user, caseworker: false, team_leader: false, regional_delivery_officer: false, team: "education_and_skills_funding_agency") }

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

    describe "active" do
      it "contains only active users" do
        active_user = create(:user, deactivated_at: nil, email: "active.user@education.gov.uk")
        inactive_user = create(:inactive_user)

        scoped_users = User.active

        expect(scoped_users).to include(active_user)
        expect(scoped_users).not_to include(inactive_user)
      end
    end

    describe "inactive" do
      it "contains only inactive users" do
        active_user = create(:user, deactivated_at: nil, email: "active.user@education.gov.uk")
        inactive_user = create(:inactive_user)

        scoped_users = User.inactive

        expect(scoped_users).to include(inactive_user)
        expect(scoped_users).not_to include(active_user)
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

    describe "#email" do
      it { is_expected.to validate_presence_of(:email) }

      it "can only have a @education.gov.uk domain" do
        user = build(:user, email: "user@not-valid-domain.gov.uk")

        expect(user).to be_invalid
      end

      it "must be unique" do
        create(:user, email: "user@education.gov.uk")
        new_user = build(:user, email: "user@education.gov.uk")

        expect(new_user).to be_invalid
      end
    end
  end

  describe "callbacks" do
    describe "before save" do
      context "when the team is regional casework services" do
        context "and team lead is not set" do
          it "assigns the caseworker role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "regional_casework_services"
            user_attributes[:team_leader] = false

            user = described_class.create!(user_attributes)

            expect(user.caseworker).to be true
            expect(user.team_leader).to be false
            expect(user.regional_delivery_officer).to be false
            expect(user.service_support).to be false
          end
        end

        context "and team lead is set" do
          it "assigns the team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "regional_casework_services"
            user_attributes[:team_leader] = true

            user = described_class.create!(user_attributes)

            expect(user.caseworker).to be false
            expect(user.team_leader).to be true
            expect(user.regional_delivery_officer).to be false
            expect(user.service_support).to be false
          end
        end
      end

      context "when the team is regional" do
        context "and team lead is not set" do
          it "assigns the regional delivery officer and team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "london"
            user_attributes[:team_leader] = false

            user = described_class.create!(user_attributes)

            expect(user.caseworker).to be false
            expect(user.team_leader).to be false
            expect(user.regional_delivery_officer).to be true
            expect(user.service_support).to be false
          end
        end

        context "and team lead is set" do
          it "assigns the regional delivery officer and team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "london"
            user_attributes[:team_leader] = true

            user = described_class.create!(user_attributes)

            expect(user.caseworker).to be false
            expect(user.team_leader).to be true
            expect(user.regional_delivery_officer).to be true
            expect(user.service_support).to be false
          end
        end
      end

      context "when the team is service support" do
        it "assigns the service support role correctly" do
          user_attributes = valid_user_attributes
          user_attributes[:team] = "service_support"
          user_attributes[:team_leader] = false

          user = described_class.create!(user_attributes)

          expect(user.caseworker).to be false
          expect(user.team_leader).to be false
          expect(user.regional_delivery_officer).to be false
          expect(user.service_support).to be true
        end
      end

      context "when the team is not regional or regional casework services" do
        it "cannot be a team lead" do
          user_attributes = valid_user_attributes
          user_attributes[:team] = "service_support"
          user_attributes[:team_leader] = true

          user = described_class.create!(user_attributes)

          expect(user.team_leader).to be false
        end
      end
    end
  end

  describe "#team_options" do
    it "returns the correct team options for a user" do
      options = described_class.new.team_options

      expect(options.count).to eql 13
      expect(options.first.id).to eql "london"
      expect(options.first.name).to eql "London"
      expect(options.last.id).to eql "education_and_skills_funding_agency"
      expect(options.last.name).to eql "ESFA (Education and Skills Funding Agency)"
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
      user = create(:user, team: "education_and_skills_funding_agency")

      expect(user.has_role?).to be false
    end
  end

  describe "#team" do
    it "uses the enum suffix as expected" do
      user = create(:user, team: "london")

      expect(user.london_team?).to be true
    end

    it "has the expected enum values" do
      expect(User.teams.count).to eq(13)
    end
  end

  def valid_user_attributes
    {
      first_name: "First",
      last_name: "Last",
      email: "first.last@education.gov.uk",
      team: "london",
      team_leader: false
    }
  end
end
