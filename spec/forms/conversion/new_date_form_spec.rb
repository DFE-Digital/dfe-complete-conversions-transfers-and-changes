require "rails_helper"

RSpec.describe Conversion::NewDateHistoryForm, type: :model do
  describe "validations" do
    it "requires a valid year" do
      form = create_valid_form_object

      form.send(:"revised_date(1i)=", "")
      expect(form).to be_invalid

      form.send(:"revised_date(1i)=", "not a string")
      expect(form).to be_invalid

      form.send(:"revised_date(1i)=", "1901")
      expect(form).to be_invalid

      form.send(:"revised_date(1i)=", "3023")
      expect(form).to be_invalid

      form.send(:"revised_date(1i)=", "23")
      expect(form).to be_invalid
    end

    it "requires a valid month" do
      form = create_valid_form_object

      form.send(:"revised_date(2i)=", "")
      expect(form).to be_invalid

      form.send(:"revised_date(2i)=", "not a string")
      expect(form).to be_invalid

      form.send(:"revised_date(2i)=", "0")
      expect(form).to be_invalid

      form.send(:"revised_date(2i)=", "24")
      expect(form).to be_invalid
    end

    it "requires the note body" do
      form = create_valid_form_object

      form.note_body = ""
      expect(form).to be_invalid
    end

    it "requires the project_id" do
      form = create_valid_form_object
      form.project_id = nil

      expect(form).to be_invalid
    end

    it "requires the user_id" do
      form = create_valid_form_object
      form.user_id = nil

      expect(form).to be_invalid
    end
  end

  describe "#save" do
    it "creates the conversion date history and note" do
      mock_successful_api_calls(establishment: 123456, trust: 12345678)
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      user = create(:user, :caseworker)
      form = create_valid_form_object
      form.project_id = project.id
      form.user_id = user.id
      form.note_body = "This is my note body."

      expect(form.save).to be true
      expect(project.conversion_dates.count).to eq 1
      expect(Note.count).to eq 1

      conversion_date_history = project.conversion_dates.first
      expect(conversion_date_history.revised_date).to eql Date.new(2023, 1, 1)

      note = conversion_date_history.note
      expect(note.user).to eql user
      expect(note.project).to eql project
      expect(note.body).to eql "This is my note body."
    end

    it "updates the project conversion date with the revised date" do
      mock_successful_api_calls(establishment: 123456, trust: 12345678)
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      user = create(:user, :caseworker)
      form = create_valid_form_object
      form.project_id = project.id
      form.user_id = user.id

      expect(form.save).to be true

      expect(project.reload.conversion_date).to eq Date.new(2023, 1, 1)
    end

    it "is transactional, it does nothing if any operation fails and returns an error" do
      mock_successful_api_calls(establishment: 123456, trust: 12345678)
      project = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month)
      form = create_valid_form_object
      form.project_id = project.id

      expect(form.save).to eq false
      expect(project.reload.conversion_date).not_to eq Date.new(2023, 1, 1)
      expect(Note.count).to be_zero
      expect(project.conversion_dates.count).to be_zero
      expect(form.errors.messages[:revised_date]).to include(I18n.t("errors.attributes.revised_date.transaction"))
    end
  end

  def create_valid_form_object
    described_class.new(
      project_id: "PROJECT_ID",
      user_id: "USER_ID",
      note_body: "Note body",
      "revised_date(3i)": "1",
      "revised_date(2i)": "1",
      "revised_date(1i)": "2023"
    )
  end
end
