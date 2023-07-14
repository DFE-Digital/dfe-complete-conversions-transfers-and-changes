require "rails_helper"

RSpec.feature "Users can view a list trusts" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when there are no projects to fetch trusts for" do
    scenario "they see an empty message" do
      visit all_trusts_projects_path

      expect(page).to have_content("There are no trusts")
    end
  end

  context "when there are projects to fetch trusts for" do
    scenario "they see the trust listed and a link" do
      project = create(:conversion_project)
      trust = build(:academies_api_trust, ukprn: project.incoming_trust_ukprn)

      visit all_trusts_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content(trust.name)
        expect(page).to have_content(trust.group_identifier)
        expect(page).to have_content("1")
        expect(page).to have_link("View projects"), href: by_trust_all_trusts_projects_path(trust.ukprn)
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      21.times do
        create(:conversion_project, incoming_trust_ukprn: 12345678)
      end

      trust = build(:academies_api_trust, ukprn: 12345678)
      allow_any_instance_of(Project).to receive(:incoming_trust).and_return(trust)

      visit by_trust_all_trusts_projects_path(trust.ukprn)

      save_page

      expect(page).to have_css(".govuk-pagination")
    end
  end
end
