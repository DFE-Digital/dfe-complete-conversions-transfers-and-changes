require "rails_helper"

RSpec.describe Conversion::Involuntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_involuntary_new_path }
  let(:workflow_root) { Conversion::Involuntary::Details::WORKFLOW_PATH }
  let(:form_class) { Conversion::Involuntary::CreateProjectForm }
  let(:project_form) { build(:create_involuntary_project_form) }
  let(:project_form_params_key) { "conversion_involuntary_create_project_form" }
  let(:project_form_params) {
    attributes_for(:create_involuntary_project_form,
      "provisional_conversion_date(3i)": "1",
      "provisional_conversion_date(2i)": "1",
      "provisional_conversion_date(1i)": "2030",
      "advisory_board_date(3i)": "1",
      "advisory_board_date(2i)": "1",
      "advisory_board_date(1i)": "2022",
      regional_delivery_officer: nil)
  }

  before do
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"
end
