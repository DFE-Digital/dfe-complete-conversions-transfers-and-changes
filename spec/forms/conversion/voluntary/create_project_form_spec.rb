require "rails_helper"

RSpec.describe Conversion::Voluntary::CreateProjectForm, type: :model do
  let(:form_factory) { "create_voluntary_project_form" }
  let(:workflow_path) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:details_class) { "Conversion::Voluntary::Details" }

  it_behaves_like "a conversion project FormObject"
end
