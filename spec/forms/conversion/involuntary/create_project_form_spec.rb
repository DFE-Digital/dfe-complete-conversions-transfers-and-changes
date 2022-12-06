require "rails_helper"

RSpec.describe Conversion::Involuntary::CreateProjectForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:trust_sharepoint_link) }

    describe "provisional_conversion_date" do
      it { is_expected.to validate_presence_of(:provisional_conversion_date) }

      it "must be in the future" do
        form = build(
          :create_involuntary_project_form,
          provisional_conversion_date: (Date.today + 1.year).at_beginning_of_month
        )
        expect(form).to be_valid

        form.provisional_conversion_date = Date.today - 1.year
        expect(form).to be_invalid
      end

      it "cannot be in the past" do
        form = build(
          :create_involuntary_project_form,
          provisional_conversion_date: (Date.today + 1.year).at_beginning_of_month
        )
        expect(form).to be_valid

        form.provisional_conversion_date = Date.today - 1.year
        expect(form).to be_invalid
      end
    end

    describe "advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date) }

      it "must be in the past" do
        form = build(
          :create_involuntary_project_form,
          advisory_board_date: Date.today - 1.week
        )
        expect(form).to be_valid

        form.advisory_board_date = Date.today + 1.month
        expect(form).to be_invalid
      end

      it "cannot be in the future" do
        form = build(
          :create_involuntary_project_form,
          advisory_board_date: Date.today - 1.week
        )
        expect(form).to be_valid

        form.advisory_board_date = Date.today + 1.month
        expect(form).to be_invalid
      end

      context "when no date value is set" do
        it "treats the date as blank" do
          form = build(:create_involuntary_project_form, advisory_board_date: nil)
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
      end
    end
  end

  describe "urn" do
    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to allow_value(123456).for(:urn) }
    it { is_expected.not_to allow_values(12345, 1234567).for(:urn) }

    context "when no establishment with that URN exists in the API" do
      let(:no_establishment_found_result) do
        AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
      end

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_establishment) { no_establishment_found_result }
      end

      it "is invalid" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe "incoming_trust_ukprn" do
    context "when no trust with that UKPRN exists in the API" do
      let(:no_trust_found_result) do
        AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe "#save" do
    let(:establishment) { build(:academies_api_establishment) }

    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)
    end

    context "when the form is valid" do
      it "returns true" do
        expect(build(:create_involuntary_project_form).save).to be true
      end

      it "creates a note if the note_body is not empty" do
        form = build(
          :create_involuntary_project_form,
          note_body: "Some important words"
        )
        form.save
        expect(Note.count).to eq(1)
        expect(Note.last.body).to eq("Some important words")
      end

      it "creates a Conversion::Involuntary::Details object" do
        form = build(:create_involuntary_project_form)
        form.save
        expect(Conversion::Details.count).to eq(1)
        expect(Conversion::Details.last.type).to eq("Conversion::Involuntary::Details")
      end

      it "calls the TaskListCreator" do
        task_list_creator = TaskListCreator.new
        allow(TaskListCreator).to receive(:new).and_return(task_list_creator)
        allow(task_list_creator).to receive(:call).and_return true
        form = build(:create_involuntary_project_form)
        form.save
        new_project = Project.last
        expect(task_list_creator).to have_received(:call)
          .with(new_project,
            workflow_root: Conversion::Involuntary::Details::WORKFLOW_PATH)
      end
    end

    context "when the form is invalid" do
      it "returns nil" do
        expect(build(:create_involuntary_project_form, urn: nil).save).to be_nil
      end
    end
  end
end
