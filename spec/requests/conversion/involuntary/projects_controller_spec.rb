require "rails_helper"

RSpec.describe Conversion::Involuntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_involuntary_new_path }
  let(:workflow_root) { Conversion::Involuntary::Details::WORKFLOW_PATH }
  let(:this_controller) { Conversion::Involuntary::ProjectsController }

  before do
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"
end
