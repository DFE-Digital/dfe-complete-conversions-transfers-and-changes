require "rails_helper"

RSpec.describe ProjectRegionMigrator do
  before do
    establishment = build(:academies_api_establishment)
    trust = build(:academies_api_trust)

    mock_successful_api_calls(establishment: establishment, trust: trust)
  end

  describe "#migrate_up!" do
    context "when the project has a region already" do
      it "does not update the region" do
        project = create(:conversion_project, region: Project.regions["london"])
        described_class.new(project).migrate_up!
        project.reload
        expect(project.region).to eq("london")
      end
    end

    context "when the project does not have a region" do
      it "updates the region" do
        project = create(:conversion_project, region: nil)
        described_class.new(project).migrate_up!
        project.reload
        expect(project.region).to eq("west_midlands")
      end
    end
  end
end
