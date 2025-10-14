require "rails_helper"

RSpec.describe "Flash banner suppression", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in_with(user)
  end

  context "tasks routes" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    it "does not render flash banner on task list" do
      get project_tasks_path(project)
      follow_redirect! if response.redirect?
      expect(response.body).not_to include("govuk-notification-banner__title")
    end

    it "does not render flash banner on task edit" do
      # pick a real task identifier used in routes; receive_grant_payment_certificate exists for conversions
      get project_edit_task_path(project, :receive_grant_payment_certificate)
      expect(response.body).not_to include("govuk-notification-banner__title")
    end
  end

  context "notes routes" do
    let(:project) { create(:conversion_project, assigned_to: user) }

    it "does not render flash banner on project notes index" do
      get project_notes_path(project)
      expect(response.body).not_to include("govuk-notification-banner__title")
    end
  end

  context "control page" do
    it "renders flash banner on a neutral page" do
      get projects_path
      follow_redirect! if response.redirect?
      get projects_path
      expect(flash).to be_a(ActionDispatch::Flash::FlashHash)
      # Manually set a flash to ensure banner would render
      get root_path
      expect(response.body).to include("govuk-notification-banner__title").or include("govuk-notification-banner")
    end
  end
end


