require "rails_helper"

RSpec.describe NewDateHistoryForm, type: :model do
  let(:project) { create(:conversion_project, conversion_date: Date.today.at_beginning_of_month) }
  let(:user) { create(:user, :caseworker) }
  let(:form) { described_class.new }

  before { mock_all_academies_api_responses }

  def valid_attributes
    revised_date = Date.today.at_beginning_of_month + 6.months
    {
      "revised_date(3i)": revised_date.day.to_s,
      "revised_date(2i)": revised_date.month.to_s,
      "revised_date(1i)": revised_date.year.to_s,
      note_body: "Test note body.",
      user: user,
      project: project
    }.with_indifferent_access
  end

  describe "validations" do
    it "can be valid in this test" do
      attributes = valid_attributes

      form.assign_attributes(attributes)

      expect(form).to be_valid
    end

    describe "revised date" do
      it "shows a helpful error message when invalid" do
        attributes = valid_attributes
        attributes["revised_date(2i)"] = "13"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
        expect(form.errors.messages_for(:revised_date)).to include(
          "Enter a valid month and year for the revised date, like 9 2024"
        )
      end

      it "cannot be empty" do
        attributes = valid_attributes
        attributes["revised_date(3i)"] = "1"
        attributes["revised_date(2i)"] = ""
        attributes["revised_date(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end

      describe "month params" do
        it "cannot be 0" do
          attributes = valid_attributes
          attributes["revised_date(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 0" do
          attributes = valid_attributes
          attributes["revised_date(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 12" do
          attributes = valid_attributes
          attributes["revised_date(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["revised_date(2i)"] = "fourth"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year params" do
        it "must be four digits" do
          attributes = valid_attributes
          attributes["revised_date(1i)"] = "25"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 2000" do
          attributes = valid_attributes
          attributes["revised_date(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 3000" do
          attributes = valid_attributes
          attributes["revised_date(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["revised_date(2i)"] = "twenty twenty five"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      it "requires the note body" do
        attributes = valid_attributes
        attributes["note_body"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end

      it "requires the project" do
        attributes = valid_attributes
        attributes["project"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end

      it "requires the user" do
        attributes = valid_attributes
        attributes["user"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid
      end
    end
  end

  describe "#save" do
    it "returns true when successful" do
      attributes = valid_attributes

      form.assign_attributes(attributes)

      expect(form.save).to be true
    end

    it "adds an error and returns false if unsuccessful" do
      attributes = valid_attributes
      attributes["note_body"] = ""

      form.assign_attributes(attributes)

      expect(form.save).to eq false
      expect(form.errors.messages_for(:note_body)).to include("Enter a reason")
    end

    it "adds an error and returns false if the data cannot be saved" do
      attributes = valid_attributes
      allow_any_instance_of(SignificantDateCreatorService).to receive("update!").and_return(false)

      form.assign_attributes(attributes)

      expect(form.save).to eq false
      expect(form.errors.messages_for(:revised_date)).to include("Revised date could not be saved")
    end
  end

  describe "works for transfers" do
    let(:project) { create(:transfer_project, transfer_date: Date.today.at_beginning_of_month) }

    it "returns true when successful" do
      attributes = valid_attributes

      form.assign_attributes(attributes)

      expect(form.save).to be true
    end

    it "adds an error and returns false if unsuccessful" do
      attributes = valid_attributes
      attributes["note_body"] = ""

      form.assign_attributes(attributes)

      expect(form.save).to eq false
      expect(form.errors.messages_for(:note_body)).to include("Enter a reason")
    end
  end
end
