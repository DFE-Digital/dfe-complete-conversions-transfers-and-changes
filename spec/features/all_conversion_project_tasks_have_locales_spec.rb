require "rails_helper"

RSpec.feature "All task lists have a locale file & all keys are present" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:involuntary_project) { create(:involuntary_conversion_project) }
  let(:voluntary_project) { create(:voluntary_conversion_project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  context "involuntary project" do
    describe "has locales for all tasks" do
      before do
        visit conversions_involuntary_project_task_list_path(involuntary_project.id)
      end

      it "has all the links for the involuntary tasks" do
        expect(page.find_all("ol.app-task-list ul li a").count).to eq 25
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.handover.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.handover.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.stakeholder_kick_off.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.stakeholder_kick_off.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.conversion_grant.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.conversion_grant.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.land_questionnaire.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.land_questionnaire.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.land_registry.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.land_registry.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.supplemental_funding_agreement.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.supplemental_funding_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.church_supplemental_agreement.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.church_supplemental_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.master_funding_agreement.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.master_funding_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.articles_of_association.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.articles_of_association.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.deed_of_variation.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.deed_of_variation.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.trust_modification_order.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.trust_modification_order.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.direction_to_transfer.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.direction_to_transfer.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.one_hundred_and_twenty_five_year_lease.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.one_hundred_and_twenty_five_year_lease.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.subleases.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.subleases.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.tenancy_at_will.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.tenancy_at_will.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.commercial_transfer_agreement.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.commercial_transfer_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.check_baseline.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.check_baseline.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.single_worksheet.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.single_worksheet.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.school_completed.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.school_completed.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.conditions_met.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.conditions_met.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.share_information.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.share_information.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.tell_regional_delivery_officer.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.tell_regional_delivery_officer.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.redact_and_send.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.redact_and_send.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.update_esfa.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.update_esfa.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.involuntary.tasks.receive_grant_payment_certificate.title")}" do
        click_on I18n.t("conversion.involuntary.tasks.receive_grant_payment_certificate.title")
        expect(page).to_not have_css(".translation_missing")
      end
    end
  end

  context "voluntary project" do
    describe "has locales for all tasks" do
      before do
        visit conversions_voluntary_project_task_list_path(voluntary_project.id)
      end

      it "has all the links for the voluntary tasks" do
        expect(page.find_all("ol.app-task-list ul li a").count).to eq 25
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.handover.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.handover.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.stakeholder_kick_off.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.conversion_grant.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.conversion_grant.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.land_questionnaire.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.land_questionnaire.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.land_registry.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.land_registry.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.supplemental_funding_agreement.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.supplemental_funding_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.church_supplemental_agreement.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.church_supplemental_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.master_funding_agreement.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.master_funding_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.articles_of_association.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.articles_of_association.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.deed_of_variation.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.deed_of_variation.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.trust_modification_order.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.trust_modification_order.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.direction_to_transfer.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.direction_to_transfer.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.one_hundred_and_twenty_five_year_lease.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.one_hundred_and_twenty_five_year_lease.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.subleases.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.subleases.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.tenancy_at_will.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.tenancy_at_will.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.commercial_transfer_agreement.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.commercial_transfer_agreement.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.check_baseline.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.check_baseline.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.single_worksheet.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.single_worksheet.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.school_completed.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.school_completed.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.conditions_met.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.conditions_met.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.share_information.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.share_information.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.tell_regional_delivery_officer.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.tell_regional_delivery_officer.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.redact_and_send.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.redact_and_send.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.update_esfa.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.update_esfa.title")
        expect(page).to_not have_css(".translation_missing")
      end

      it "has locales for #{I18n.t("conversion.voluntary.tasks.receive_grant_payment_certificate.title")}" do
        click_on I18n.t("conversion.voluntary.tasks.receive_grant_payment_certificate.title")
        expect(page).to_not have_css(".translation_missing")
      end
    end
  end
end
