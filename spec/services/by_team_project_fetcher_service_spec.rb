require "rails_helper"

RSpec.describe ByTeamProjectFetcherService do
  describe "#in_progress" do
    before { mock_all_academies_api_responses }

    let!(:conversion_project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: Date.today.at_beginning_of_month) }
    let!(:conversion_project_london) { create(:conversion_project, team: "regional_casework_services", region: "london") }
    let!(:transfer_project_rcs) { create(:transfer_project, team: "regional_casework_services", region: "north_east", transfer_date: Date.today.at_beginning_of_month) }
    let!(:transfer_project_london) { create(:transfer_project, team: "regional_casework_services", region: "london", transfer_date: Date.today.at_beginning_of_month + 2.years) }

    context "when the user is in the 'regional_casework_services' team" do
      let!(:project_rcs_2) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: (Date.today + 1.month).at_beginning_of_month) }

      it "returns all projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).in_progress
        expect(result).to include(conversion_project_rcs, conversion_project_london, transfer_project_rcs, transfer_project_london)
      end

      it "orders projects by significant date" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).in_progress
        expect(result.first.significant_date).to eq(Date.today.at_beginning_of_month)
        expect(result.last.significant_date).to eq(Date.today.at_beginning_of_month + 2.years)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).in_progress
        expect(result).to include(conversion_project_london, transfer_project_london)
        expect(result).to_not include(conversion_project_rcs, transfer_project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).in_progress).to eq([])
    end

    it "returns an empty array when the user's team is not RCS or a region" do
      user = create(:user, team: "service_support")
      expect(described_class.new(user.team).in_progress).to eq([])
    end
  end

  describe "#new" do
    before do
      freeze_time
      mock_all_academies_api_responses
    end

    after do
      unfreeze_time
    end

    let!(:conversion_project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: Date.today.at_beginning_of_month + 1.month, created_at: DateTime.now) }
    let!(:conversion_project_london) { create(:conversion_project, team: "regional_casework_services", region: "london", created_at: DateTime.now - 1.day) }
    let!(:transfer_project_rcs) { create(:transfer_project, team: "regional_casework_services", region: "north_east", transfer_date: Date.today.at_beginning_of_month + 1.month, created_at: DateTime.now - 2.day) }
    let!(:transfer_project_london) { create(:transfer_project, team: "regional_casework_services", region: "london", transfer_date: Date.today.at_beginning_of_month + 2.years, created_at: DateTime.now - 3.day) }

    context "when the user is in the 'regional_casework_services' team" do
      let!(:project_rcs_2) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: (Date.today + 1.month).at_beginning_of_month) }

      it "returns all projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).new
        expect(result).to include(conversion_project_rcs, conversion_project_london, transfer_project_rcs, transfer_project_london)
      end

      it "orders projects by created_at date" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).new

        expect(result.first.created_at).to eq(DateTime.now)
        expect(result.last.created_at).to eq(DateTime.now - 3.day)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).new
        expect(result).to include(conversion_project_london, transfer_project_london)
        expect(result).to_not include(conversion_project_rcs, transfer_project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).new).to eq([])
    end

    it "returns an empty array when the user's team is not RCS or a region" do
      user = create(:user, team: "service_support")
      expect(described_class.new(user.team).new).to eq([])
    end
  end

  describe "#completed" do
    before { mock_all_academies_api_responses }

    let!(:conversion_project_rcs) { create(:conversion_project, :completed, team: "regional_casework_services", region: "north_east", completed_at: Date.yesterday) }
    let!(:conversion_project_london) { create(:conversion_project, :completed, team: "regional_casework_services", region: "london", completed_at: Date.yesterday) }
    let!(:transfer_project_rcs) { create(:transfer_project, :completed, team: "regional_casework_services", region: "north_east", completed_at: Date.yesterday) }
    let!(:transfer_project_london) { create(:transfer_project, :completed, team: "regional_casework_services", region: "london", completed_at: Date.yesterday) }

    context "when the user is in the 'regional_casework_services' team" do
      it "returns all completed projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).completed
        expect(result).to include(conversion_project_rcs, conversion_project_london, transfer_project_rcs, transfer_project_london)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).completed
        expect(result).to include(conversion_project_london, transfer_project_london)
        expect(result).to_not include(conversion_project_rcs, transfer_project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).completed).to eq([])
    end
  end

  describe "#unassigned" do
    before { mock_all_academies_api_responses }

    let!(:conversion_project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", assigned_to: nil) }
    let!(:conversion_project_london) { create(:conversion_project, team: "regional_casework_services", region: "london", assigned_to: nil) }
    let!(:transfer_project_rcs) { create(:transfer_project, team: "regional_casework_services", region: "north_east", assigned_to: nil) }
    let!(:transfer_project_london) { create(:transfer_project, team: "regional_casework_services", region: "london", assigned_to: nil) }

    context "when the user is in the 'regional_casework_services' team" do
      it "returns all in-progress projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).unassigned
        expect(result).to include(conversion_project_rcs, conversion_project_london, transfer_project_rcs, transfer_project_london)
      end

      it "does not include completed, deleted or DAO revoked projects" do
        user = build(:user, team: "regional_casework_services")
        completed_project = create(:conversion_project, :completed, team: "regional_casework_services", assigned_to: nil)
        deleted_project = create(:conversion_project, :deleted, team: "regional_casework_services", assigned_to: nil)
        dao_revoked_project = create(:conversion_project, :dao_revoked, team: "regional_casework_services", assigned_to: nil)

        result = described_class.new(user.team).unassigned
        expect(result).not_to include(completed_project, deleted_project, dao_revoked_project)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).unassigned
        expect(result).to include(conversion_project_london, transfer_project_london)
        expect(result).to_not include(conversion_project_rcs, transfer_project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).unassigned).to eq([])
    end
  end

  describe "#users" do
    before { mock_all_academies_api_responses }

    it "returns a sorted list of users in the user's team, with their assigned_to project counts" do
      user_1 = create(:user, :caseworker, team: "regional_casework_services", first_name: "Abbie")
      user_2 = create(:user, :caseworker, team: "regional_casework_services", first_name: "Ben")
      user_3 = create(:user, :caseworker, team: "regional_casework_services", first_name: "Claire")
      _user_4 = create(:user, :caseworker, team: "regional_casework_services", first_name: "Danniella")
      user_5 = create(:user, team: "london")
      _project_1 = create(:conversion_project, assigned_to: user_1)
      _project_2 = create(:conversion_project, assigned_to: user_2)
      _project_3 = create(:conversion_project, assigned_to: user_3)
      _project_4 = create(:conversion_project, assigned_to: user_1)
      _project_5 = create(:conversion_project, assigned_to: user_5)
      _project_6 = create(:transfer_project, assigned_to: user_3)
      _project_7 = create(:transfer_project, assigned_to: user_3)

      result = described_class.new(user_1.team).users
      expect(result[0].name).to eq("Abbie Doe")
      expect(result[0].conversion_count).to eq(2)
      expect(result[1].name).to eq("Ben Doe")
      expect(result[1].conversion_count).to eq(1)
      expect(result[2].name).to eq("Claire Doe")
      expect(result[2].conversion_count).to eq(1)
      expect(result[2].transfer_count).to eq(2)
      expect(result[3].name).to eq("Danniella Doe")
      expect(result[3].conversion_count).to eq(0)
      expect(result).to_not include(user_5.full_name)
    end

    it "only returns in_progress projects" do
      user = create(:user, :caseworker, team: "regional_casework_services", first_name: "Abbie")
      _project_1 = create(:conversion_project, assigned_to: user)
      _project_2 = create(:conversion_project, :completed, assigned_to: user, completed_at: Date.yesterday)

      result = described_class.new(user.team).users
      expect(result[0].name).to eq("Abbie Doe")
      expect(result[0].conversion_count).to eq(1)
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).users).to eq([])
    end
  end
end
