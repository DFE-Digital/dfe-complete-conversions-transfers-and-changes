require "rails_helper"

RSpec.describe Conversions::DateHistoriesController do
  describe "#create" do
    it "fails when the form is invalid" do
      user = create(:user, :caseworker)
      sign_in_with(user)
      mock_successful_api_calls(establishment: any_args, trust: any_args)
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month, conversion_date_provisional: false)
      mock_successful_api_establishment_response(urn: project.urn)

      post conversions_involuntary_project_conversion_date_path(project), params: {conversion_new_date_history_form: {revised_date: nil, note_body: nil}}

      expect(response).to render_template :new
    end
  end
end
