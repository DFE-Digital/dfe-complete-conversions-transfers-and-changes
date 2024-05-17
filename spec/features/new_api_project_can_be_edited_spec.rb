require "rails_helper"

RSpec.feature "A new conversion project created via the API can be edited and validated" do
  let(:user) { create(:user, :regional_delivery_officer) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  scenario "the project information page" do
    project = Conversion::Project.new(urn: 123456,
      incoming_trust_ukprn: 100000001,
      conversion_date: Date.new(2025, 1, 1),
      advisory_board_date: Date.yesterday,
      tasks_data: Conversion::TasksData.new,
      state: 3)
    project.save(validate: false)
    visit project_information_path(project)
  end
end
