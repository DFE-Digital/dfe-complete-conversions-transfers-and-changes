require "rails_helper"

RSpec.describe DaoRevocationsController, type: :request do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, directive_academy_order: true, assigned_to: user) }

  before do
    sign_in_with(user)
    mock_all_academies_api_responses
  end

  describe "only revokable projects" do
    it "redirects to the project view unless the project is dao revokable" do
      project = create(:conversion_project, directive_academy_order: false, assigned_to: user)

      get project_dao_revocation_start_path(project)

      expect(response).to redirect_to project_path(project)
      follow_redirect!
      follow_redirect!
      expect(response.body).to include "Only conversion projects with a DAO"

      project = create(:transfer_project, assigned_to: user)

      get project_dao_revocation_start_path(project)

      expect(response).to redirect_to project_path(project)
      follow_redirect!
      follow_redirect!
      expect(response.body).to include "Only conversion projects with a DAO"
    end

    it "renders when the project is DAO revokable" do
      project = create(:conversion_project, directive_academy_order: true, assigned_to: user)

      get project_dao_revocation_start_path(project)

      expect(response).to render_template "start"
    end
  end

  describe "#step" do
    it "renders the template for the step" do
      get project_dao_revocation_step_path(project, :reasons)

      expect(response).to render_template "reasons"
    end

    it "renders 404 for unknown steps" do
      get project_dao_revocation_step_path(project, :unknown_step)

      expect(response).to render_template "page_not_found"
      expect(response).to have_http_status :not_found
    end

    it "deleted the stored values on the first step" do
      valid_params = {dao_revocation_stepped_form: {minister_name: "Minister Name"}}

      post project_dao_revocation_update_step_path(project, :minister, params: valid_params)

      expect(cache_store_value(project, user)).to be_truthy

      get project_dao_revocation_step_path(project, :confirm)

      expect(cache_store_value(project, user)).to be_nil
    end
  end

  describe "#update_step" do
    it "sets the values in the cache when the form is valid" do
      valid_params = {dao_revocation_stepped_form: {minister_name: "Minister Name"}}

      post project_dao_revocation_update_step_path(project, :minister, params: valid_params)

      expect(cache_store_value(project, user)).to eql(
        {
          reason_school_closed: "",
          reason_school_closed_note: "",
          reason_school_rating_improved: "",
          reason_school_rating_improved_note: "",
          reason_safeguarding_addressed: "",
          reason_safeguarding_addressed_note: "",
          reason_change_to_policy: "",
          reason_change_to_policy_note: "",
          minister_name: "Minister Name",
          date_of_decision: ""
        }
      )
    end

    it "shows an error when the form is invalid for the step" do
      valid_params = {dao_revocation_stepped_form: {minister_name: ""}}

      post project_dao_revocation_update_step_path(project, :minister, params: valid_params)

      expect(response).to render_template "minister"
      expect(response.body).to include "There is a problem"
    end

    it "redirects to the next step when the form is valid for the step" do
      valid_params = {dao_revocation_stepped_form: {minister_name: "Minister Name"}}

      post project_dao_revocation_update_step_path(project, :minister, params: valid_params)

      expect(response).to redirect_to project_dao_revocation_step_path(project, :date)
    end

    it "redirects to the check answers view on the last step" do
      valid_params = {dao_revocation_stepped_form: {date_of_decision: Date.yesterday}}

      post project_dao_revocation_update_step_path(project, :date, params: valid_params)

      expect(response).to redirect_to project_dao_revocation_check_path(project)
    end
  end

  describe "#change_step" do
    it "renders the change template for the step" do
      get project_dao_revocation_change_step_path(project, :reasons)

      expect(response).to render_template "change_reasons"
    end

    it "renders 404 for unknown steps" do
      get project_dao_revocation_change_step_path(project, :unknown_step)

      expect(response).to render_template "page_not_found"
      expect(response).to have_http_status :not_found
    end
  end

  describe "#update_change_step" do
    it "sets the values in the cache when the form is valid" do
      valid_params = {dao_revocation_stepped_form: {minister_name: "Incorrect Name"}}

      post project_dao_revocation_update_step_path(project, :minister, params: valid_params)

      valid_params = {dao_revocation_stepped_form: {minister_name: "Minister Name"}}

      patch project_dao_revocation_update_change_step_path(project, :minister, params: valid_params)

      expect(cache_store_value(project, user)).to eql(
        {
          reason_school_closed: "",
          reason_school_closed_note: "",
          reason_school_rating_improved: "",
          reason_school_rating_improved_note: "",
          reason_safeguarding_addressed: "",
          reason_safeguarding_addressed_note: "",
          reason_change_to_policy: "",
          reason_change_to_policy_note: "",
          minister_name: "Minister Name",
          date_of_decision: ""
        }
      )
    end

    it "shows an error when the form is invalid for the step" do
      valid_params = {dao_revocation_stepped_form: {minister_name: ""}}

      patch project_dao_revocation_update_change_step_path(project, :minister, params: valid_params)

      expect(response).to render_template "change_minister"
      expect(response.body).to include "There is a problem"
    end

    it "redirects to the check answers view for every step" do
      valid_params = {dao_revocation_stepped_form: {minister_name: "Minister Name"}}

      patch project_dao_revocation_update_change_step_path(project, :minister, params: valid_params)

      expect(response).to redirect_to project_dao_revocation_check_path(project)
    end
  end

  describe "#check" do
    let(:valid_params) do
      {
        dao_revocation_stepped_form:
        {
          date_of_decision: "2024-01-01",
          reason_school_closed: "true",
          reason_school_closed_note: "Details of the school closing.",
          reason_school_rating_improved: "false",
          reason_school_rating_improved_note: nil,
          reason_safeguarding_addressed: "false",
          reason_safeguarding_addressed_note: nil,
          reason_change_to_policy: "true",
          reason_change_to_policy_note: "The policy changed",
          minister_name: "Minister Name"
        }
      }
    end

    before do
      patch project_dao_revocation_update_change_step_path(project, :minister, params: valid_params)
    end

    it "gets the stored values" do
      get project_dao_revocation_check_path(project)

      expect(cache_store_value(project, user)).to eql(
        {
          reason_school_closed: "true",
          reason_school_closed_note: "Details of the school closing.",
          reason_school_rating_improved: "false",
          reason_school_rating_improved_note: "",
          reason_safeguarding_addressed: "false",
          reason_safeguarding_addressed_note: "",
          reason_change_to_policy: "true",
          reason_change_to_policy_note: "The policy changed",
          minister_name: "Minister Name",
          date_of_decision: "2024-01-01"
        }
      )
    end

    it "redirects to the start unless the form is checkable" do
      not_checkable_params = {
        dao_revocation_stepped_form:
        {
          date_of_decision: "",
          reason_school_closed: "",
          reason_school_rating_improved: "",
          reason_safeguarding_addressed: "",
          reason_change_to_policy: "",
          minister_name: "Minister Name"
        }
      }
      patch project_dao_revocation_update_change_step_path(project, :minister, params: not_checkable_params)

      get project_dao_revocation_check_path(project)

      expect(response).to redirect_to project_dao_revocation_start_path(project)
    end
  end

  describe "#save" do
    let(:valid_params) do
      {
        dao_revocation_stepped_form:
        {
          reason_school_closed: "true",
          reason_school_closed_note: "Details of the school closing.",
          reason_school_rating_improved: "false",
          reason_school_rating_improved_note: nil,
          reason_safeguarding_addressed: "false",
          reason_safeguarding_addressed_note: nil,
          reason_change_to_policy: "false",
          reason_change_to_policy_note: nil,
          minister_name: "Minister Name",
          date_of_decision: "2024-1-1"
        }
      }
    end

    before do
      patch project_dao_revocation_update_change_step_path(project, :minister, params: valid_params)
    end

    it "creates a new DAO Revocation record" do
      expect { post project_dao_revocation_check_path(project) }.to change { DaoRevocation.count }
    end

    it "deletes the stored values" do
      post project_dao_revocation_check_path(project)

      expect(cache_store_value(project, user)).to be_nil
    end

    it "redirects to the project task page" do
      post project_dao_revocation_check_path(project)

      expect(response).to redirect_to project_path(project)
    end

    it "renders the check answers page and shows an error when invalid" do
      allow_any_instance_of(DaoRevocation).to receive(:valid?).and_return(false)

      post project_dao_revocation_check_path(project)

      expect(response).to render_template "check"
      expect(response.body).to include "Cannot record DAO revocation, check your answers"
    end
  end

  def cache_store_value(project, user)
    Rails.cache.read("dao_revocation:project_#{project.id}:user_#{user.id}")
  end
end
