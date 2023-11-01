require "rails_helper"

RSpec.feature "Service support users can upload GIAS data" do
  let(:user) { create(:user, :service_support) }

  before do
    sign_in_with_user(user)
  end

  scenario "a service support user can successfully upload GIAS data for ingestion" do
    visit service_support_upload_gias_establishments_new_path

    attach_file(I18n.t("service_support.import.gias_establishments.upload_form.label"), Rails.root + "spec/fixtures/files/gias_establishment_data_good.csv")
    click_on "Continue"
    expect(page).to have_content(I18n.t("service_support.import.gias_establishments.success", time: "0100"))
  end

  scenario "a service support user sees an error message after uploading an invalid file" do
    visit service_support_upload_gias_establishments_new_path

    attach_file(I18n.t("service_support.import.gias_establishments.upload_form.label"), Rails.root + "spec/fixtures/files/gias_establishment_data_bad.csv")
    click_on "Continue"
    expect(page).to have_content(I18n.t("errors.upload.attributes.uploaded_file.file_headers"))
  end

  scenario "a service support user sees an error message after submitting the form without attaching a file" do
    visit service_support_upload_gias_establishments_new_path

    click_on "Continue"
    expect(page).to have_content(I18n.t("errors.upload.attributes.uploaded_file.no_file"))
  end
end
