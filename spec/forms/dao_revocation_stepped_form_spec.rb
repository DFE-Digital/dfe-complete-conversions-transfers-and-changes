require "rails_helper"

RSpec.describe DaoRevocationSteppedForm, type: :model do
  describe "steps" do
    it "returns the correct steps in order" do
      expect(described_class.steps).to eql [:confirm, :reasons, :minister, :date]
    end

    it "returns the first step" do
      expect(described_class.first_step).to eql :confirm
    end

    it "returns the last step" do
      expect(described_class.last_step).to eql :date
    end
  end

  describe "validations" do
    it "validates that all confirmations are checked on the confirm step" do
      form = described_class.new(
        confirm_minister_approved: true,
        confirm_letter_sent: false,
        confirm_letter_saved: true
      )

      expect(form).to be_invalid(:confirm)
      expect(form.errors.messages_for(:base)).to include "You must complete all of the tasks"
    end

    it "validates that at least one reason is checked on the reasons step" do
      form = described_class.new(
        reason_school_closed: false,
        reason_school_rating_improved: false,
        reason_safeguarding_addressed: false,
        reason_change_to_policy: false
      )

      expect(form).to be_invalid(:reasons)
      expect(form.errors.messages_for(:reasons)).to include "Select at least one reason"
    end

    it { is_expected.to validate_presence_of(:minister_name).on :minister }
    it { is_expected.to validate_presence_of(:date_of_decision).on :date }

    describe "date of decision" do
      let(:valid_attributes) do
        date_of_decision = Date.today
        {
          "date_of_decision(3i)": date_of_decision.day.to_s,
          "date_of_decision(2i)": date_of_decision.month.to_s,
          "date_of_decision(1i)": date_of_decision.year.to_s
        }.with_indifferent_access
      end

      let(:form) { described_class.new }

      it "shows a helpful error message when invalid" do
        attributes = valid_attributes
        attributes["date_of_decision(2i)"] = "13"

        form.assign_attributes(attributes)

        expect(form).to be_invalid(:date)
        expect(form.errors.messages_for(:date_of_decision)).to include(
          "Enter a valid date the decision was made, like 27 3 2021"
        )
      end

      it "cannot be empty" do
        attributes = valid_attributes
        attributes["date_of_decision(3i)"] = ""
        attributes["date_of_decision(2i)"] = ""
        attributes["date_of_decision(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_invalid(:date)
      end

      describe "day params" do
        it "cannot be 0" do
          attributes = valid_attributes
          attributes[:"date_of_decision(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be less than 0" do
          attributes = valid_attributes
          attributes["date_of_decision(3i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be more than 31" do
          attributes = valid_attributes
          attributes["date_of_decision(3i)"] = "32"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_of_decision(3i)"] = "fourth"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end
      end

      describe "month params" do
        it "cannot be 0" do
          attributes = valid_attributes
          attributes[:"date_of_decision(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be less than 0" do
          attributes = valid_attributes
          attributes["date_of_decision(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be more than 12" do
          attributes = valid_attributes
          attributes["date_of_decision(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_of_decision(2i)"] = "fourth"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end
      end

      describe "year params" do
        it "must be four digits" do
          attributes = valid_attributes
          attributes["date_of_decision(1i)"] = "25"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be less than 2000" do
          attributes = valid_attributes
          attributes["date_of_decision(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "cannot be more than 3000" do
          attributes = valid_attributes
          attributes["date_of_decision(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_of_decision(2i)"] = "twenty twenty five"

          form.assign_attributes(attributes)

          expect(form).to be_invalid(:date)
        end
      end
    end
  end

  describe "#reasons" do
    it "returns an array of the reasons" do
      form = described_class.new(
        reason_school_closed: true,
        reason_school_rating_improved: false,
        reason_safeguarding_addressed: true,
        reason_change_to_policy: false
      )

      expect(form.reasons).to eql [:reason_school_closed, :reason_safeguarding_addressed]
    end
  end

  describe "#reasons_empty?" do
    it "returns true when all the reasons are false" do
      form = described_class.new(
        reason_school_closed: false,
        reason_school_rating_improved: false,
        reason_safeguarding_addressed: false,
        reason_change_to_policy: false
      )

      expect(form.reasons_empty?).to be true
    end

    it "returns false when any reason is true" do
      form = described_class.new(
        reason_school_closed: false,
        reason_school_rating_improved: true,
        reason_safeguarding_addressed: false,
        reason_change_to_policy: false
      )

      expect(form.reasons_empty?).to be false
    end
  end

  describe "#checkable?" do
    it "returns true when all the minimum required attributes are present" do
      form = described_class.new(
        reason_school_closed: true,
        reason_school_rating_improved: false,
        reason_safeguarding_addressed: false,
        minister_name: "Minister Name",
        date_of_decision: "2024-1-1"
      )

      expect(form.checkable?).to be true
    end

    it "returns false when any of the minimum required attributes are not present" do
      form = described_class.new(
        reason_school_closed: "",
        reason_school_rating_improved: "",
        reason_safeguarding_addressed: "",
        minister_name: "",
        date_of_decision: "2024-1-1"
      )

      expect(form.checkable?).to be false
    end
  end

  describe "#to_h" do
    it "returns a hash of the attributes that need to be stored" do
      form = described_class.new(
        reason_school_closed: true,
        reason_school_rating_improved: false,
        reason_safeguarding_addressed: true,
        reason_change_to_policy: false,
        reason_school_closed_note: "The reason the school is closing.",
        reason_school_rating_improved_note: "The school rating improved because.",
        reason_safeguarding_addressed_note: "The safeguarding concern has been addresses like this.",
        reason_change_to_policy_note: "",
        minister_name: "Minister Name",
        date_of_decision: Date.today
      )

      expect(form.to_h).to eql({
        reason_school_closed: "true",
        reason_school_rating_improved: "false",
        reason_safeguarding_addressed: "true",
        reason_change_to_policy: "false",
        reason_school_closed_note: "The reason the school is closing.",
        reason_school_rating_improved_note: "The school rating improved because.",
        reason_safeguarding_addressed_note: "The safeguarding concern has been addresses like this.",
        reason_change_to_policy_note: "",
        minister_name: "Minister Name",
        date_of_decision: Date.today.to_s
      })
    end
  end

  describe "#save" do
    before do
      mock_all_academies_api_responses
    end

    let(:valid_form) do
      described_class.new(
        reason_school_closed_note: "The reason the school is closing.",
        reason_school_rating_improved_note: "The school rating improved because.",
        reason_safeguarding_addressed_note: "The safeguarding concern has been addresses like this.",
        minister_name: "Minister Name",
        date_of_decision: Date.today
      )
    end

    let(:user) { create(:user) }

    it "creates the DaoRevocation and saves it to the project returning true" do
      project = create(:conversion_project, directive_academy_order: true)

      result = valid_form.save(project, user)

      expect(result).to be true
      expect(DaoRevocation.count).to be 1

      dao_revocation = DaoRevocation.last
      expect(dao_revocation.decision_makers_name).to eql "Minister Name"
      expect(dao_revocation.date_of_decision).to eql Date.today
    end

    it "updates the project state to dao_revoked" do
      project = create(:conversion_project, directive_academy_order: true)

      valid_form.save(project, user)

      expect(project.reload.state).to eql "dao_revoked"
    end

    it "returns false and adds an error when invalid" do
      project = create(:conversion_project, directive_academy_order: false)

      result = valid_form.save(project, user)

      expect(result).to be false
      expect(valid_form.errors.messages_for(:base)).to include "Cannot record DAO revocation, check your answers"
    end
  end
end
