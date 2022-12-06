require "rails_helper"

RSpec.describe Conversion::Involuntary::CreateProjectForm, type: :model do
  let(:form_factory) { "create_involuntary_project_form" }
  let(:workflow_path) { Conversion::Involuntary::Details::WORKFLOW_PATH }
  let(:details_class) { "Conversion::Involuntary::Details" }

  it_behaves_like "a conversion project FormObject"
end
