require "rails_helper"

RSpec.feature "Form a multi academy trust" do
  before do
    user = create(:user)
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let!(:conversion_project) {
    create(
      :conversion_project,
      :form_a_mat,
      urn: 122957,
      new_trust_name: "The Big trust",
      new_trust_reference_number: "TR12345"
    )
  }

  let!(:transfer_project) {
    create(
      :transfer_project,
      :form_a_mat,
      urn: 138205,
      new_trust_name: "The Big trust",
      new_trust_reference_number: "TR12345"
    )
  }

  scenario "users can view the group of projects" do
    visit form_a_multi_academy_trust_path("TR12345")

    expect(page).to have_selector("span.govuk-caption-l", text: "TR12345")
    expect(page).to have_selector("h1.govuk-heading-xl", text: "The Big trust")

    within("tbody.govuk-table__body") do
      expect(page).to have_content(conversion_project.urn)
      expect(page).to have_content(transfer_project.urn)
    end
  end
end
