require "rails_helper"

RSpec.describe ByRegionProjectFetcherService do
  describe "#project_counts" do
    it "returns a sorted list of simple view objects with project counts" do
      mock_successful_api_response_to_create_any_project

      create(:conversion_project, region: "south_west")
      create(:conversion_project, region: "london")
      create(:conversion_project, region: "south_west")
      create(:conversion_project, region: "north_west")
      create(:transfer_project, region: "south_west")
      create(:transfer_project, region: "london")

      result = described_class.new.project_counts

      expect(result.count).to eql 3

      first_result = result.first

      expect(first_result.name).to eql "london"
      expect(first_result.conversion_count).to eql 1
      expect(first_result.transfer_count).to eql 1

      last_result = result.last

      expect(last_result.name).to eql "south_west"
      expect(last_result.conversion_count).to eql 2
      expect(last_result.transfer_count).to eql 1
    end

    it "returns an empty array when there are no projects to source trusts" do
      expect(described_class.new.project_counts).to eql []
    end
  end

  describe "#regional_casework_services_projects" do
    before do
      mock_successful_api_response_to_create_any_project
    end

    it "returns all projects in the specificed region which are assigned to regional casework services" do
      user = create(:user, team: "london")
      conversion_project = create(:conversion_project, region: "london", team: "regional_casework_services")
      conversion_project_2 = create(:conversion_project, region: "north_west", team: "regional_casework_services")
      conversion_project_3 = create(:conversion_project, region: "london", team: "london")

      expect(described_class.new.regional_casework_services_projects(user.team)).to include(conversion_project)
      expect(described_class.new.regional_casework_services_projects(user.team)).to_not include(conversion_project_2, conversion_project_3)
    end

    it "returns an empty array if there are no matching projects" do
      user = create(:user, team: "london")

      expect(described_class.new.regional_casework_services_projects(user.team)).to match_array []
    end

    it "does not include completed, deleted or dao_revoked projects" do
      user = create(:user, team: "london")
      _completed_project = create(:conversion_project, :completed, region: "london", team: "regional_casework_services")
      _deleted_project = create(:conversion_project, :deleted, region: "north_west", team: "regional_casework_services")
      _dao_revoked_project = create(:conversion_project, :dao_revoked, region: "north_west", team: "regional_casework_services")

      expect(described_class.new.regional_casework_services_projects(user.team)).to match_array []
    end
  end
end
