require "rails_helper"

RSpec.feature "All task lists have a locale file & all keys are present" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:involuntary_project) { create(:involuntary_conversion_project) }
  let(:voluntary_project) { create(:voluntary_conversion_project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  voluntary_tasks = %w[articles_of_association church_supplemental_agreement commercial_transfer_agreement
    conditions_met conversion_grant deed_of_variation direction_to_transfer handover land_questionnaire land_registry
    master_funding_agreement one_hundred_and_twenty_five_year_lease receive_grant_payment_certificate redact_and_send
    school_completed share_information single_worksheet stakeholder_kick_off subleases supplemental_funding_agreement
    tenancy_at_will trust_modification_order update_esfa sponsored_support_grant]

  context "voluntary project" do
    describe "has locales for all tasks" do
      before do
        visit project_conversion_tasks_path(voluntary_project.id)
      end

      it "has all the links for the voluntary tasks" do
        expect(page.find_all("ol.app-task-list ul li a").count).to eq voluntary_tasks.count
        expect(page).to_not have_css(".translation_missing")
      end

      voluntary_tasks.each do |task|
        it "has locales for #{I18n.t("conversion.voluntary.tasks.#{task}.title")}" do
          click_on I18n.t("conversion.voluntary.tasks.#{task}.title")
          expect(page).to_not have_css(".translation_missing")
        end
      end
    end
  end
end
