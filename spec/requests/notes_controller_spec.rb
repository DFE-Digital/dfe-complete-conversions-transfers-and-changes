require "rails_helper"

RSpec.describe NotesController, type: :request do
  let(:user) { create(:user, :caseworker) }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 123456, ukprn: 10061021)
    allow_any_instance_of(NotesController).to receive(:user_id).and_return(user.id)
  end

  describe "#index" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get project_notes_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#new" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }

    subject(:perform_request) do
      get new_project_note_path(project_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#create" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:mock_note) { build(:note) }
    let(:new_note_body) { "Just had an interesting chat about building regulations." }
    let(:params) { {note: {body: new_note_body}} }

    subject(:perform_request) do
      post project_notes_path(project_id), params: params
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the note is invalid" do
      before do
        allow(Note).to receive(:new).and_return(mock_note)
        allow(mock_note).to receive(:valid?).and_return false
      end

      it "renders the new template" do
        expect(perform_request).to render_template :new
      end
    end

    context "when the note is valid" do
      it "saves the note and redirects to the index view with a success message" do
        expect(subject).to redirect_to(project_notes_path(project.id))
        expect(request.flash[:notice]).to eq(I18n.t("note.create.success"))

        expect(Note.count).to be 1
        expect(Note.last.body).to eq(new_note_body)
        expect(Note.last.task).to be_nil
      end

      context "when the note has a task_id" do
        let(:task) { create(:task) }
        let(:params) { {note: {body: new_note_body, task_id: task.id}} }

        it "saves the note and redirects to the index view with a success message" do
          expect(subject).to redirect_to(project_notes_path(project.id))
          expect(request.flash[:notice]).to eq(I18n.t("note.create.success"))

          expect(Note.count).to be 1
          expect(Note.last.body).to eq(new_note_body)
          expect(Note.last.task).to eq task
        end
      end
    end
  end

  describe "#edit" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:note) { create(:note, user: user) }
    let(:note_id) { note.id }

    subject(:perform_request) do
      get edit_project_note_path(project_id, note_id)
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Note is not found" do
      let(:note_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the user did not create the note" do
      let(:note) { create(:note) }

      it "redirects to the home page with a permissions error message" do
        perform_request
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end

  describe "#update" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:note) { create(:note, user: user) }
    let(:note_id) { note.id }
    let(:new_note_body) { "This is an updated note body" }

    subject(:perform_request) do
      put project_note_path(project_id, note_id), params: {note: {body: new_note_body}}
      response
    end

    context "when the Project is not found" do
      let(:project_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the Note is not found" do
      let(:note_id) { SecureRandom.uuid }

      it { expect { perform_request }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "when the user did not create the note" do
      let(:note) { create(:note) }

      it "redirects to the home page with a permissions error message" do
        perform_request
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    context "when the note is invalid" do
      before do
        allow(Note).to receive(:find).and_return(note)
        allow(note).to receive(:valid?).and_return false
      end

      it "renders the edit template" do
        expect(perform_request).to render_template :edit
      end
    end

    context "when the note is valid" do
      it "saves the note and redirects to the index view with a success message" do
        expect(subject).to redirect_to(project_notes_path(project.id))
        expect(request.flash[:notice]).to eq(I18n.t("note.update.success"))

        expect(Note.count).to be 1
        expect(Note.last.body).to eq(new_note_body)
      end
    end
  end

  describe "#destroy" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:note) { create(:note, user: user) }
    let(:note_id) { note.id }

    subject(:perform_request) do
      delete project_note_path(project_id, note_id)
      response
    end

    context "when the user did not create the note" do
      let(:note) { create(:note) }

      it "redirects to the home page with a permissions error message" do
        perform_request
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    it "deletes the note and redirects to the index view with a success message" do
      expect(perform_request).to redirect_to(project_notes_path(project.id))
      expect(request.flash[:notice]).to eq(I18n.t("note.destroy.success"))

      expect(Note.where(id: note_id)).to_not exist
    end
  end

  describe "#confirm_destroy" do
    let(:project) { create(:project) }
    let(:project_id) { project.id }
    let(:note) { create(:note, user: user) }
    let(:note_id) { note.id }

    subject(:perform_request) do
      get project_note_delete_path(project_id, note_id)
      response
    end

    context "when the user did not create the note" do
      let(:note) { create(:note) }

      it "redirects to the home page with a permissions error message" do
        perform_request
        expect(response).not_to render_template(:edit)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(flash.alert).to eq I18n.t("unauthorised_action.message")
      end
    end

    it "returns a successful response" do
      expect(subject).to have_http_status :success
    end
  end
end
