require "rails_helper"

RSpec.feature "Users can view project openers in table form" do
  let(:team_leader) { create(:user, :team_leader) }

  before do
    mock_all_academies_api_responses
    sign_in_with(team_leader)
  end

  context "All conditions met tag" do
    context "when a project has all conditions met" do
      it "shows the correct value" do
        _project = create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, all_conditions_met: true)

        visit "/projects/all/by-month/confirmed/1/2023"
        expect(page).to have_content("Yes")
      end
    end

    context "when a project does not have all conditions met" do
      it "shows the correct value" do
        _project = create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false, all_conditions_met: nil)

        visit "/projects/all/by-month/confirmed/1/2023"
        expect(page).to have_content("Not yet")
      end
    end
  end
end
