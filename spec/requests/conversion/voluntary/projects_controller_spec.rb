require "rails_helper"

RSpec.describe Conversion::Voluntary::ProjectsController, type: :request do
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer) }
  let(:create_path) { conversion_voluntary_new_path }
  let(:workflow_root) { Conversion::Voluntary::Details::WORKFLOW_PATH }
  let(:this_controller) { Conversion::Voluntary::ProjectsController }

  before do
    mock_successful_authentication(regional_delivery_officer.email)
    allow_any_instance_of(Conversion::Voluntary::ProjectsController).to receive(:user_id).and_return(regional_delivery_officer.id)
  end

  it_behaves_like "a conversion project"
end
