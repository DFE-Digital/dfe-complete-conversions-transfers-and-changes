require "rails_helper"

RSpec.feature "Users can view project information" do
  include ActionView::Helpers::TextHelper

  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:project, :with_conditions, caseworker: user) }
  let(:project_id) { project.id }

  before do
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    sign_in_with_user(user)
    visit project_information_path(project_id)
  end

  scenario "they can view the users names and email addresses assigned to the project" do
    within("#projectDetails") do
      expect(page).to have_content(user.full_name)
      expect(page).to have_link("Email caseworker", href: "mailto:#{user.email}")

      expect(page).to have_content(project.team_leader.full_name)
      expect(page).to have_link("Email team leader", href: "mailto:#{project.team_leader.email}")

      expect(page).to have_content(project.regional_delivery_officer.full_name)
      expect(page).to have_link("Email regional delivery officer", href: "mailto:#{project.regional_delivery_officer.email}")
    end
  end

  scenario "they can view the advisory board details" do
    within("#projectDetails") do
      expect(page).to have_content(project.advisory_board_date.to_formatted_s(:govuk))
      expect(page.html).to include(simple_format(project.advisory_board_conditions, class: "govuk-body"))
    end
  end

  scenario "they can view the School SharePoint link" do
    within("#projectDetails") do
      expect(page).to have_link(project.establishment_sharepoint_link, href: project.establishment_sharepoint_link)
    end
  end

  scenario "they can view the school details" do
    within("#schoolDetails") do
      expect(page).to have_content(project.establishment.name)
      expect(page).to have_content(project.urn)
      expect(page).to have_content(project.establishment.type)
      expect(page).to have_content(project.establishment.phase)
      expect(page).to have_content(project.establishment.region_name)
    end
  end

  scenario "they can view the trust details" do
    within("#trustDetails") do
      expect(page).to have_content(project.incoming_trust.name)
      expect(page).to have_content(project.incoming_trust_ukprn)
      expect(page).to have_content(project.incoming_trust.companies_house_number)
    end
  end

  scenario "the local authority details" do
    within("#localAuthorityDetails") do
      expect(page).to have_content(project.establishment.local_authority)
    end
  end

  scenario "the diocese details" do
    within("#dioceseDetails") do
      expect(page).to have_content(project.establishment.diocese_name)
    end
  end
end
