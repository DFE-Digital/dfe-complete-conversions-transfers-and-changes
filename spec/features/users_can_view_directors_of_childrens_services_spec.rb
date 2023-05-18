require "rails_helper"

RSpec.feature "Users can view internal contacts for a project" do
  let(:user) { create(:user, :service_support) }

  before do
    sign_in_with(user)
  end

  let(:a_council) { create(:local_authority, name: "A-town council") }
  let(:z_council) { create(:local_authority, name: "Z-town council") }
  let!(:dcs_a) { create(:director_of_child_services, local_authority: a_council) }
  let!(:dcs_z) { create(:director_of_child_services, local_authority: z_council) }

  scenario "The Directors of Children Services are ordered by their Local authority name" do
    visit directors_of_child_services_path

    expect(page.find(".govuk-table__body tr:first-of-type").text).to include("A-town council")
    expect(page.find(".govuk-table__body tr:last-of-type").text).to include("Z-town council")
  end
end
