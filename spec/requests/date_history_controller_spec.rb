require "rails_helper"

RSpec.describe DateHistoryController do
  describe "#create" do
    it "fails when the form is invalid" do
      user = create(:user, :caseworker)
      sign_in_with(user)
      mock_successful_api_calls(establishment: any_args, trust: any_args)
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false, assigned_to: user)
      mock_successful_api_establishment_response(urn: project.urn)

      post project_date_history_path(project), params: {new_date_history_form: {revised_date: nil}}

      expect(response).to render_template :new
    end
  end
end
