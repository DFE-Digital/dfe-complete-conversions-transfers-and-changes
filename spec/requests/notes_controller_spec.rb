require "rails_helper"

RSpec.describe NotesController, type: :request do
  let(:user) { User.create!(email: "user@education.gov.uk") }

  before do
    mock_successful_authentication(user.email)
    mock_successful_api_responses(urn: 12345, ukprn: 10061021)
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

    subject(:perform_request) do
      post project_notes_path(project_id), params: {note: {body: new_note_body}}
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
      end
    end
  end
end
