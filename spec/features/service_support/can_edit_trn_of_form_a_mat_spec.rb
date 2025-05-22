require "rails_helper"

RSpec.feature "Service support can edit TRN of 'Form a MAT'" do
  before do
    mock_successful_api_response_to_create_any_project
  end

  scenario "can edit new trust reference number (TRN) of 'Form a MAT' conversion" do
    given_i_am_logged_in_as_a_service_support_user
    and_a_form_a_mat_conversion_exists

    when_i_go_to_edit_the_incoming_trust_details
    then_i_should_be_able_to_edit_the_form_a_mats_trn

    when_i_edit_the_trn
    then_i_see_that_the_new_trn_has_been_applied
  end

  scenario "can edit new trust reference number (TRN) of 'Form a MAT' transfer" do
    given_i_am_logged_in_as_a_service_support_user
    and_a_form_a_mat_transfer_exists

    when_i_go_to_edit_the_incoming_trust_details
    then_i_should_be_able_to_edit_the_form_a_mats_trn

    when_i_edit_the_trn
    then_i_see_that_the_new_trn_has_been_applied
  end

  scenario "can NOT use a TRN which is in use with a different #new_trust_name" do
    given_i_am_logged_in_as_a_service_support_user
    and_a_form_a_mat_transfer_exists
    and_another_form_a_mat_exists_with_same_number_but_different_new_trust_name

    when_i_attempt_to_change_the_trn_to_the_number_already_in_use_with_a_different_name
    then_i_see_an_error_message_explaining_the_validation_error
  end

  def given_i_am_logged_in_as_a_service_support_user
    service_support_user = FactoryBot.create(
      :user,
      :service_support,
      first_name: "Service",
      last_name: "Support",
      email: "service.support@education.gov.uk"
    )

    sign_in_with_user(service_support_user)
  end

  def and_a_form_a_mat_conversion_exists
    @project = FactoryBot.create(
      :form_a_mat_conversion_project,
      new_trust_name: "A Brand New Trust Being Created",
      new_trust_reference_number: "TR54321",
      local_authority: FactoryBot.create(:local_authority)
    )
  end

  def and_a_form_a_mat_transfer_exists
    @project = FactoryBot.create(
      :transfer_project,
      :form_a_mat,
      new_trust_name: "A Brand New Trust Being Created",
      new_trust_reference_number: "TR54321",
      local_authority: FactoryBot.create(:local_authority)
    )
  end

  def and_another_form_a_mat_exists_with_same_number_but_different_new_trust_name
    FactoryBot.create(
      :form_a_mat_conversion_project,
      new_trust_name: "A DIFFERENT New Trust Being Created",
      new_trust_reference_number: "TR22334",
      local_authority: FactoryBot.create(:local_authority)
    )
  end

  def when_i_go_to_edit_the_incoming_trust_details
    visit project_path(@project)
    click_link "About the project"

    within "#incomingTrustDetails .trn" do
      expect(page).to have_content("TR54321")
      click_link("Change")
    end
  end

  def then_i_should_be_able_to_edit_the_form_a_mats_trn
    # binding.pry
    within "#new_trust_reference_number" do
      expect(page).to have_field("Trust reference number (TRN)", with: "TR54321")
    end
  end

  def when_i_edit_the_trn
    within "#new_trust_reference_number" do
      fill_in("Trust reference number", with: "TR22334")
    end
    click_button("Continue")
  end

  def then_i_see_that_the_new_trn_has_been_applied
    visit project_path(@project)
    click_link "About the project"

    within "#incomingTrustDetails .trn" do
      expect(page).to have_content("TR22334")
    end
  end

  def when_i_attempt_to_change_the_trn_to_the_number_already_in_use_with_a_different_name
    when_i_go_to_edit_the_incoming_trust_details
    when_i_edit_the_trn
  end

  def then_i_see_an_error_message_explaining_the_validation_error
    msg = "A trust with this TRN already exists. It is called A DIFFERENT New Trust Being Created."
    within ".govuk-error-summary" do
      expect(page).to have_content(msg)
    end
  end
end
