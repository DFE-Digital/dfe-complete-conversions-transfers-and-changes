require "rails_helper"

RSpec.feature "Users can view project openers in table form" do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    sign_in_with(team_leader)
  end

  context "All conditions met tag" do
    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
    end

    context "when a project has all conditions met" do
      it "shows the correct tag" do
        tasks_data = create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: true)
        _project = create(:conversion_project, tasks_data: tasks_data, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false)

        visit confirmed_all_opening_projects_path(1, 2023)
        expect(page).to have_css("strong.govuk-tag--turquoise", text: "confirmed")
      end
    end

    context "when a project does not have all conditions met" do
      it "shows the correct tag" do
        tasks_data = create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: nil)
        _project = create(:conversion_project, tasks_data: tasks_data, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false)

        visit confirmed_all_opening_projects_path(1, 2023)
        expect(page).to have_css("strong.govuk-tag--blue", text: "unconfirmed")
      end
    end
  end
end
