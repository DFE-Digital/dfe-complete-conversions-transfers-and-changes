require "rails_helper"

RSpec.describe NewDateHistoryForm, type: :model do
  let(:form) { create_valid_form_object }

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

    it "requires the project" do
      form = create_valid_form_object
      form.project = nil

      expect(form).to be_invalid
    end

    it "requires the user" do
      form = create_valid_form_object
      form.user = nil

      expect(form).to be_invalid
    end
  end

  describe "#save" do
    let(:project) { create(:conversion_project, conversion_date: Date.today.at_beginning_of_month) }
    let(:user) { create(:user, :caseworker) }

    before { mock_successful_api_calls(establishment: any_args, trust: any_args) }

    it "returns true when successful" do
      form.project = project
      form.user = user
      form.note_body = "This is my note body."

      expect(form.save).to be true
    end

    it "adds an error and returns false if unsuccessful" do
      form.project = project
      form.user = user

      allow_any_instance_of(SignificantDateCreatorService).to receive("update!").and_return(false)

      expect(form.save).to eq false
      expect(form.errors.messages[:revised_date]).to include(I18n.t("errors.attributes.revised_date.transaction"))
    end
  end

  def create_valid_form_object
    described_class.new(
      project: build(:conversion_project),
      user: build(:user),
      note_body: "Note body",
      "revised_date(3i)": "1",
      "revised_date(2i)": "1",
      "revised_date(1i)": "2023"
    )
  end
end
