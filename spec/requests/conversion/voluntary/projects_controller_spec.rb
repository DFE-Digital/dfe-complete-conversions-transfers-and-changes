require "rails_helper"

RSpec.describe Conversion::Voluntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_voluntary_new_path }
  let(:workflow_root) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:this_controller) { Conversion::Voluntary::ProjectsController }

  before do
    sign_in_with(regional_delivery_officer)
  end

  it_behaves_like "a conversion project"
end
