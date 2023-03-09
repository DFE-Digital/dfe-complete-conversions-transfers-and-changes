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
        task_list = create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: true)
        _project = create(:conversion_project, task_list: task_list, conversion_date: Date.new(2023, 1, 1))

        visit openers_projects_path(1, 2023)
        expect(page).to have_css("strong.govuk-tag--turquoise", text: "yes")
      end
    end

    context "when a project does not have all conditions met" do
      it "shows the correct tag" do
        task_list = create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: nil)
        _project = create(:conversion_project, task_list: task_list, conversion_date: Date.new(2023, 1, 1))

        visit openers_projects_path(1, 2023)
        expect(page).to have_css("strong.govuk-tag--blue", text: "not started")
      end
    end
  end
end
