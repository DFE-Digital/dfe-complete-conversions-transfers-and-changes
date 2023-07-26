require "rails_helper"

RSpec.feature "All task lists have a locale file & all keys are present" do
  let(:user) { create(:user, :regional_delivery_officer) }
  let(:project) { create(:conversion_project) }

  before do
    mock_successful_api_responses(urn: any_args, ukprn: any_args)
    sign_in_with_user(user)
  end

  describe "conversion tasks" do
    before do
      visit project_tasks_path(project)
    end

    it "links to all the tasks" do
      expect(page.find_all("ol.app-task-list ul li a").count).to eq Conversion::TaskList.identifiers.count
      expect(page).to_not have_css(".translation_missing")
    end

    Conversion::TaskList.identifiers.each do |task_identifier|
      it "has locales for #{I18n.t("conversion.task.#{task_identifier}.title")}" do
        click_on I18n.t("conversion.task.#{task_identifier}.title")
        expect(page).to_not have_css(".translation_missing")
      end
    end
  end
end
