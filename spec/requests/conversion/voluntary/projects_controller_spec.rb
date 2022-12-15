require "rails_helper"

RSpec.describe Conversion::Voluntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_voluntary_new_path }
  let(:workflow_root) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:form_class) { Conversion::Voluntary::CreateProjectForm }
  let(:project_form) { build(:create_voluntary_project_form) }
  let(:project_form_params) {
    attributes_for(:create_voluntary_project_form,
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
