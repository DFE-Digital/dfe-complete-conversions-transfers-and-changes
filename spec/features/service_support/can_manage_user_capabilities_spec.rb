require "rails_helper"

RSpec.feature "Service support can manage user capabilties" do
  scenario "can edit assigned capabilities" do
    given_i_am_logged_in_as_a_service_support_user
    and_a_user_has_capabilities_1_and_3_assigned
    when_i_view_their_user_record
    then_i_see_capabilities_1_and_3_are_assigned
    and_i_see_guidance_and_warning_on_assigning_capabilities
    and_i_see_further_info_on_each_capability

    when_i_edit_their_capabilities_to_be_2_and_4
    then_i_see_capabilities_2_and_4_are_assigned
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

  def and_a_user_has_capabilities_1_and_3_assigned
    @subject_user = create(:user, first_name: "Other", last_name: "User", email: "other.user@education.gov.uk")
    @subject_user.capabilities = [Capability.all_capabilities.first, Capability.all_capabilities.third]
  end

  def when_i_view_their_user_record
    visit edit_service_support_user_path(@subject_user)
  end

  def then_i_see_capabilities_1_and_3_are_assigned
    within(".capabilities") do
      expect(page).to have_field(Capability.all_capabilities.first.name, checked: true)
      expect(page).to have_field(Capability.all_capabilities.third.name, checked: true)

      expect(page).to have_field(Capability.all_capabilities.second.name, checked: false)
      expect(page).to have_field(Capability.all_capabilities.fourth.name, checked: false)
    end
  end

  def and_i_see_guidance_and_warning_on_assigning_capabilities
    within(".capabilities") do
      expect(page).to have_css(".hint", text: "Does the user need any special capabilities?")
      expect(page).to have_css(".govuk-inset-text", text: "Use with caution")
    end
  end

  def and_i_see_further_info_on_each_capability
    within(".capabilities") do
      Capability.all_capabilities.each do |capability|
        expect(page).to have_css(".govuk-checkboxes__item .govuk-hint", text: capability.description)
      end
    end
  end

  def when_i_edit_their_capabilities_to_be_2_and_4
    within(".capabilities") do
      check Capability.all_capabilities.second.name
      check Capability.all_capabilities.fourth.name

      uncheck Capability.all_capabilities.first.name
      uncheck Capability.all_capabilities.third.name
    end

    click_button("Save user")
  end

  def then_i_see_capabilities_2_and_4_are_assigned
    visit edit_service_support_user_path(@subject_user)
    within(".capabilities") do
      expect(page).to have_field(Capability.all_capabilities.second.name, checked: true)
      expect(page).to have_field(Capability.all_capabilities.fourth.name, checked: true)

      expect(page).to have_field(Capability.all_capabilities.first.name, checked: false)
      expect(page).to have_field(Capability.all_capabilities.third.name, checked: false)
    end
  end
end
