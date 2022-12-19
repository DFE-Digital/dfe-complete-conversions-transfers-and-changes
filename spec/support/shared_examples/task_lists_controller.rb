require "rails_helper"

RSpec.shared_examples "a task lists controller" do
  let(:user) { create(:user, :caseworker) }

  before do
    sign_in_with(user)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
  end

  describe "#index" do
    subject(:perform_request) do
      get index_path
      response
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success

      expect(response.body).to include "Task list"
    end
  end

  describe "#edit" do
    let(:task_identifier) { task.class.identifier }

    subject(:perform_request) do
      get edit_path
      response
    end

    it "renders a task from the task template path" do
      expect(perform_request).to have_http_status :success
      expect(response).to render_template edit_template_path
    end
  end

  describe "#update" do
    let(:task_identifier) { task.class.identifier }

    subject(:perform_request) do
      put update_path, params: update_params
      response
    end

    it "saves the task against the task list and redirects to the task list index page" do
      perform_request

      expect(project.reload.task_list).to have_attributes(expected_update_attributes)
      expect(response).to redirect_to(index_path)
    end

    context "when the task is invalid" do
      before { allow_any_instance_of(task.class).to receive(:valid?).and_return(false) }

      it "renders the task template path" do
        perform_request

        expect(response).to render_template edit_template_path
      end
    end
  end
end
