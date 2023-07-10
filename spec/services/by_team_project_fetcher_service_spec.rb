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
end
