require "rails_helper"

RSpec.describe ProjectPathHelper, type: :helper do
  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  context "when the project is a voluntary conversion" do
    it "returns the correct paths" do
      project = create(:voluntary_conversion_project)

      expect(helper.path_to_project(project)).to eq conversions_voluntary_project_path(project)
      expect(helper.path_to_project_task_list(project)).to eq conversions_voluntary_project_task_list_path(project)
      expect(helper.path_to_project_information(project)).to eq conversions_voluntary_project_information_path(project)
      expect(helper.path_to_project_notes(project)).to eq conversions_voluntary_project_notes_path(project)
      expect(helper.path_to_project_contacts(project)).to eq conversions_voluntary_project_contacts_path(project)

      expect(helper.path_to_team_lead_project_assignment(project)).to eq conversions_voluntary_project_assign_team_lead_path(project)
      expect(helper.path_to_regional_delivery_officer_project_assignment(project)).to eq conversions_voluntary_project_assign_regional_delivery_officer_path(project)
      expect(helper.path_to_assigned_to_project_assignment(project)).to eq conversions_voluntary_project_assign_assigned_to_path(project)
      expect(helper.path_to_new_conversion_date(project)).to eq conversions_voluntary_project_conversion_date_path(project)
    end
  end
end
