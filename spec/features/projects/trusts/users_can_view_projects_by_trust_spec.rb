require "rails_helper"

RSpec.feature "Users can view a list trusts" do
  before do
    sign_in_with_user(user)
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
      mock_all_academies_api_responses
      create(:conversion_project, incoming_trust_ukprn: 10061021)
      create(:conversion_project, incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "BIG NEW TRUST")

      visit all_trusts_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content("Big New Trust")
        expect(page).to have_content("TR12345")
        expect(page).to have_content("1")
        expect(page).to have_link("Big New Trust", href: by_trust_reference_all_trusts_projects_path("TR12345"))
      end

      within("tbody > tr:last-child") do
        expect(page).to have_content("The Romero Catholic Academy")
        expect(page).to have_content("TR100610")
        expect(page).to have_content("1")
        expect(page).to have_link("The Romero Catholic Academy", href: by_trust_ukprn_all_trusts_projects_path(10061021))
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      mock_all_academies_api_responses

      21.times do
        create(:conversion_project, incoming_trust_ukprn: 10061021)
      end

      visit by_trust_ukprn_all_trusts_projects_path(10061021)

      expect(page).to have_css(".govuk-pagination")
    end
  end
end
