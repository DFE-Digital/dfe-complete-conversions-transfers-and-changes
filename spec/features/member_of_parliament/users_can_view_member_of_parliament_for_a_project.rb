require "rails_helper"

RSpec.feature "Users can view the Member of Parliament for a project" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, assigned_to: user) }
  let(:member_name) { build(:members_api_name) }
  let(:member_contact_details) { build(:members_api_contact_details) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "when the MP details are found" do
    before do
      mock_successful_members_api_responses(member_name: member_name, member_contact_details: [member_contact_details])
    end

    it "shows the MP details" do
      visit conversions_voluntary_project_mp_path(project)
      expect(page).to have_content(I18n.t("member_of_parliament.show.rows.full_title"))

      expect(page).to have_content(member_name.name_full_title)
      expect(page).to have_content(member_contact_details.email)
      within("address.govuk-address") do
        expect(page).to have_content(member_contact_details.line1)
        expect(page).to have_content(member_contact_details.line2)
        expect(page).to have_content(member_contact_details.postcode)
      end
    end
  end
end
