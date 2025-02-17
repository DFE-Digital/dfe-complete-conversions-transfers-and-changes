require "rails_helper"

RSpec.describe User do
  describe "Columns" do
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:first_name).of_type :string }
    it { is_expected.to have_db_column(:last_name).of_type :string }
    it { is_expected.to have_db_column(:manage_team).of_type :boolean }
    it { is_expected.to have_db_column(:add_new_project).of_type :boolean }
    it { is_expected.to have_db_column(:assign_to_project).of_type :boolean }
    it { is_expected.to have_db_column(:manage_user_accounts).of_type :boolean }
    it { is_expected.to have_db_column(:manage_user_accounts).of_type :boolean }
    it { is_expected.to have_db_column(:manage_local_authorities).of_type :boolean }
    it { is_expected.to have_db_column(:active_directory_user_group_ids).of_type :string }
    it { is_expected.to have_db_column(:team).of_type :string }
    it { is_expected.to have_db_column(:deactivated_at).of_type :datetime }
    it { is_expected.to have_db_column(:latest_session).of_type :datetime }
  end

  describe "associations" do
    it { is_expected.to have_many(:capabilities) }
  end

  describe "scopes" do
    let!(:caseworker) { create(:regional_casework_services_user) }
    let!(:caseworker_2) { create(:regional_casework_services_user, first_name: "Aaron", email: "aaron-caseworker@education.gov.uk") }
    let!(:team_leader) { create(:regional_casework_services_team_lead_user, first_name: "Zoe") }
    let!(:team_leader_2) { create(:regional_casework_services_team_lead_user, first_name: "Andy", email: "aaron-team-leader@education.gov.uk") }
    let!(:regional_delivery_officer_team_lead) { create(:regional_delivery_officer_user, manage_team: true, email: "rdo.lead@education.gov.uk") }
    let!(:regional_delivery_officer) { create(:regional_delivery_officer_user, first_name: "Zavier") }
    let!(:regional_delivery_officer_2) { create(:regional_delivery_officer_user, first_name: "Adam", email: "aaron-rdo@education.gov.uk") }
    let!(:user_without_role) { create(:user, assign_to_project: false, manage_team: false, add_new_project: false, team: "data_consumers") }

    describe "order_by_first_name" do
      it "orders by first_name" do
        expect(User.order_by_first_name.count).to be 8
        expect(User.order_by_first_name.first).to eq caseworker_2
        expect(User.order_by_first_name.last).to eq team_leader
      end
    end

    describe "regional casework services team leaders" do
      it "only includes users that have the team leader role sorted by first_name" do
        expect(User.regional_casework_services_team_leads.count).to be 2
        expect(User.regional_casework_services_team_leads.first).to eq team_leader_2
        expect(User.regional_casework_services_team_leads.last).to eq team_leader
      end
    end

    describe "regional delivery officer team leaders" do
      it "only includes users that have the team leader role sorted by first_name" do
        expect(User.regional_delivery_officer_team_leads.count).to be 1
        expect(User.regional_delivery_officer_team_leads.first).to eq regional_delivery_officer_team_lead
      end
    end

    describe "regional_delivery_officers" do
      it "only includes users that have the regional delivery officer role sorted by first_name" do
        expect(User.regional_delivery_officers.count).to be 3
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

    describe "assignable" do
      it "only includes users who have the assign_to_projects flag" do
        expect(User.assignable.count).to eq 5
        expect(User.assignable).to_not include(user_without_role)
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

    describe "by_team" do
      it "returns users in the desired team" do
        expect(User.by_team("north_west")).to include(regional_delivery_officer)
        expect(User.by_team("regional_casework_services")).to include(caseworker, team_leader)
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

      it "the validation is not case sensitve" do
        user = build(:user, email: "USER@EDUCATION.GOV.UK")

        expect(user).to be_valid
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
            user_attributes[:manage_team] = false

            user = described_class.create!(user_attributes)

            expect(user.assign_to_project).to be true
            expect(user.manage_team).to be false
            expect(user.add_new_project).to be true
            expect(user.manage_user_accounts).to be false
            expect(user.manage_local_authorities).to be false
            expect(user.manage_conversion_urns).to be false
          end

          it "still sets `add_new_project` to `false` in the database, even though the override method returns true" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "regional_casework_services"
            user_attributes[:manage_team] = false

            user = described_class.create!(user_attributes)

            sql = "SELECT add_new_project FROM Users WHERE id = '#{user.id}'"
            result = ActiveRecord::Base.connection.exec_query(sql)
            expect(result.rows[0]).to eq([false])
          end
        end

        context "and team lead is set" do
          it "assigns the team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "regional_casework_services"
            user_attributes[:manage_team] = true

            user = described_class.create!(user_attributes)

            expect(user.assign_to_project).to be false
            expect(user.manage_team).to be true
            expect(user.add_new_project).to be false
            expect(user.manage_user_accounts).to be false
            expect(user.manage_local_authorities).to be false
            expect(user.manage_conversion_urns).to be false
          end
        end
      end

      context "when the team is regional" do
        context "and team lead is not set" do
          it "assigns the regional delivery officer and team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "london"
            user_attributes[:manage_team] = false

            user = described_class.create!(user_attributes)

            expect(user.assign_to_project).to be true
            expect(user.manage_team).to be false
            expect(user.add_new_project).to be true
            expect(user.manage_user_accounts).to be false
            expect(user.manage_local_authorities).to be false
            expect(user.manage_conversion_urns).to be false
          end
        end

        context "and team lead is set" do
          it "assigns the regional delivery officer and team leader role correctly" do
            user_attributes = valid_user_attributes
            user_attributes[:team] = "london"
            user_attributes[:manage_team] = true

            user = described_class.create!(user_attributes)

            expect(user.assign_to_project).to be true
            expect(user.manage_team).to be true
            expect(user.add_new_project).to be true
            expect(user.manage_user_accounts).to be false
            expect(user.manage_local_authorities).to be false
            expect(user.manage_conversion_urns).to be false
          end
        end
      end

      context "when the team is service support" do
        it "assigns the service support role correctly" do
          user_attributes = valid_user_attributes
          user_attributes[:team] = "service_support"
          user_attributes[:manage_team] = false

          user = described_class.create!(user_attributes)

          expect(user.assign_to_project).to be false
          expect(user.manage_team).to be false
          expect(user.add_new_project).to be false
          expect(user.manage_user_accounts).to be true
          expect(user.manage_local_authorities).to be true
          expect(user.manage_conversion_urns).to be true
        end
      end

      context "when the team is not regional or regional casework services" do
        it "cannot be a team lead" do
          user_attributes = valid_user_attributes
          user_attributes[:team] = "service_support"
          user_attributes[:manage_team] = true

          user = described_class.create!(user_attributes)

          expect(user.manage_team).to be false
        end
      end

      describe "when overriding with user capabilities" do
        let(:user) { create(:user) }

        before do
          expect(user.manage_team).to be false
          expect(user.add_new_project).to be false
          expect(user.assign_to_project).to be false
        end

        context "when the user has the manage_team capability" do
          before do
            user.capabilities << Capability.manage_team
            user.save
          end

          it "sets the User#manage_team attribute" do
            expect(user.manage_team).to be true
          end
        end

        context "when the user has the add_new_project capability" do
          before do
            user.capabilities << Capability.add_new_project
            user.save
          end

          it "sets the User#add_new_project method (overrides the db attribute)" do
            expect(user.add_new_project).to be true
          end

          it "sets the User#add_new_project attribute" do
            expect(user.read_attribute(:add_new_project)).to be true
          end
        end

        context "when the user has the assign_to_project capability" do
          before do
            user.capabilities << Capability.assign_to_project
            user.save
          end

          it "sets the User#assign_to_project attribute" do
            expect(user.assign_to_project).to be true
          end
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
      expect(options.last.id).to eql "data_consumers"
      expect(options.last.name).to include "Data consumers"
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
      user = build(:user, team: "data_consumers")

      expect(user.has_role?).to be false
    end
  end

  describe "#is_service_support?" do
    it "returns true when the user is in the service support team" do
      user = build(:user, team: "service_support")

      expect(user.is_service_support?).to be true
    end
  end

  describe "#team" do
    it "uses the enum suffix as expected" do
      user = build(:user, team: "london")

      expect(user.london_team?).to be true
    end

    it "has the expected enum values" do
      expect(User.teams.count).to eq(13)
    end
  end

  describe "#active" do
    it "returns true when deactivated_at is nil" do
      user = build(:user)

      expect(user.active).to be true
    end

    it "returns false when deactivated_at has a value" do
      user = build(:inactive_user)

      expect(user.active).to be false
    end

    it "can be set with 1 and 0 strings" do
      user = build(:user)

      user.update!(active: "0")

      expect(user.active).to be false

      user.update!(active: "1")

      expect(user.active).to be true
    end

    it "can be set with true and false" do
      user = build(:user)

      user.update!(active: false)

      expect(user.active).to be false

      user.update!(active: true)

      expect(user.active).to be true
    end
  end

  describe "#is_regional_caseworker?" do
    it "returns true when the user is in the RCS team and is not a team lead" do
      caseworker_user = build(:regional_casework_services_user)
      other_user = build(:regional_casework_services_team_lead_user)

      expect(caseworker_user.is_regional_caseworker?).to be true
      expect(other_user.is_regional_caseworker?).to be false
    end
  end

  describe "#is_regional_delivery_officer?" do
    it "returns true when the user is in one of the regional teams" do
      regional_delivery_officer_user = build(:regional_delivery_officer_user)
      other_user = build(:regional_casework_services_team_lead_user)

      expect(regional_delivery_officer_user.is_regional_delivery_officer?).to be true
      expect(other_user.is_regional_caseworker?).to be false
    end

    it "returns true when the regional delivery officer is also a team lead" do
      rdo_user = build(:regional_delivery_officer_user)
      rdo_team_lead_user = build(:regional_delivery_officer_team_lead_user)

      expect(rdo_user.is_regional_delivery_officer?).to be true
      expect(rdo_team_lead_user.is_regional_delivery_officer?).to be true
    end
  end

  describe "#add_new_project" do
    context "when the user is an RCS user" do
      it "returns true" do
        user = build(:regional_casework_services_user)
        expect(user.add_new_project).to be true
      end
    end
    context "when the user is an RDO user" do
      it "returns true" do
        user = build(:regional_delivery_officer_user)
        expect(user.add_new_project).to be true
      end
    end
    context "when the user is any other user" do
      it "returns false" do
        user = build(:service_support_user)
        expect(user.add_new_project).to be false
      end
    end
  end

  def valid_user_attributes
    {
      first_name: "First",
      last_name: "Last",
      email: "first.last@education.gov.uk",
      team: "london",
      manage_team: false
    }
  end
end
