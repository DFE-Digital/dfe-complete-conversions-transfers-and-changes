require "rails_helper"

RSpec.describe ByTeamProjectFetcherService do
  before { mock_successful_api_response_to_create_any_project }

  describe "#in_progress" do
    let(:project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: Date.today.at_beginning_of_month) }
    let(:project_london) { create(:conversion_project, team: "regional_casework_services", region: "london") }

    context "when the user is in the 'regional_casework_services' team" do
      let(:project_rcs_2) { create(:conversion_project, team: "regional_casework_services", region: "north_east", conversion_date: (Date.today + 1.month).at_beginning_of_month) }

      it "returns all projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).in_progress
        expect(result).to include(project_rcs, project_london)
      end

      it "orders projects by conversion date" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).in_progress
        expect(result).to eq([project_rcs, project_rcs_2])
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).in_progress
        expect(result).to include(project_london)
        expect(result).to_not include(project_rcs)
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

  describe "#completed" do
    let(:project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", completed_at: Date.yesterday) }
    let(:project_london) { create(:conversion_project, team: "regional_casework_services", region: "london", completed_at: Date.yesterday) }

    context "when the user is in the 'regional_casework_services' team" do
      it "returns all completed projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).completed
        expect(result).to include(project_rcs, project_london)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).completed
        expect(result).to include(project_london)
        expect(result).to_not include(project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).completed).to eq([])
    end
  end

  describe "#unassigned" do
    let(:project_rcs) { create(:conversion_project, team: "regional_casework_services", region: "north_east", assigned_to: nil) }
    let(:project_london) { create(:conversion_project, team: "regional_casework_services", region: "london", assigned_to: nil) }

    context "when the user is in the 'regional_casework_services' team" do
      it "returns all in-progress projects where the project's team is regional_casework_services" do
        user = build(:user, team: "regional_casework_services")

        result = described_class.new(user.team).unassigned
        expect(result).to include(project_rcs, project_london)
      end
    end

    context "when the user's team is a region" do
      it "returns all projects where the project's region is the same as the user's team" do
        user = build(:user, team: "london")

        result = described_class.new(user.team).unassigned
        expect(result).to include(project_london)
        expect(result).to_not include(project_rcs)
      end
    end

    it "returns an empty array when the user's team is nil" do
      user = build(:user, team: nil)
      expect(described_class.new(user.team).unassigned).to eq([])
    end
  end

  describe "#users" do
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

      result = described_class.new(user_1.team).users
      expect(result[0].name).to eq("Abbie Doe")
      expect(result[0].conversion_count).to eq(2)
      expect(result[1].name).to eq("Ben Doe")
      expect(result[1].conversion_count).to eq(1)
      expect(result[2].name).to eq("Claire Doe")
      expect(result[2].conversion_count).to eq(1)
      expect(result[3].name).to eq("Danniella Doe")
      expect(result[3].conversion_count).to eq(0)
      expect(result).to_not include(user_5.full_name)
    end

    it "only returns in_progress projects" do
      user = create(:user, :caseworker, team: "regional_casework_services", first_name: "Abbie")
      _project_1 = create(:conversion_project, assigned_to: user)
      _project_2 = create(:conversion_project, assigned_to: user, completed_at: Date.yesterday)

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
