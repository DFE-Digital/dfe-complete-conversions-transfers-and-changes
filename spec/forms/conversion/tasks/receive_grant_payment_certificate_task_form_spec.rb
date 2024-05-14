require "rails_helper"

RSpec.describe Conversion::Task::ReceiveGrantPaymentCertificateTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }
  let(:form) { described_class.new(project.tasks_data, user) }

  before { mock_successful_api_response_to_create_any_project }

  def valid_attributes
    date_received = Date.today.at_beginning_of_month + 6.months
    {
      "date_received(3i)": date_received.day.to_s,
      "date_received(2i)": date_received.month.to_s,
      "date_received(1i)": date_received.year.to_s,
      check_certificate: "false",
      save_certificate: "false"
    }.with_indifferent_access
  end

  describe "validations" do
    describe "date_received" do
      it "shows a helpful error message when invalid" do
        attributes = valid_attributes
        attributes["date_received(1i)"] = "13"

        form.assign_attributes(attributes)

        expect(form).to be_invalid
        expect(form.errors.messages_for(:date_received)).to include(
          "Enter a valid date, like 1 1 2025"
        )
      end

      it "can be empty" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = ""
        attributes["date_received(2i)"] = ""
        attributes["date_received(1i)"] = ""

        form.assign_attributes(attributes)

        expect(form).to be_valid
      end

      describe "day parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 31" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "32"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(3i)"] = "twenty first"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "month params" do
        it "cannot be 0" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "0"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 0" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "-1"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 12" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "13"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "fourth"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year params" do
        it "must be four digits" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "25"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be less than 2000" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "1999"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "cannot be more than 3000" do
          attributes = valid_attributes
          attributes["date_received(1i)"] = "3001"

          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["date_received(2i)"] = "twenty twenty five"
          form.assign_attributes(attributes)

          expect(form).to be_invalid
        end
      end
    end
  end

  describe "#save" do
    context "when the date is a valid date" do
      it "sets date_received to the supplied date" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = "1"
        attributes["date_received(2i)"] = "1"
        attributes["date_received(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to eq(Date.new(2024, 1, 1))
      end
    end

    context "when form is invalid" do
      it "shows a helpful message" do
        attributes = valid_attributes
        attributes["date_received(3i)"] = "32"
        attributes["date_received(2i)"] = "1"
        attributes["date_received(1i)"] = "2024"

        form.assign_attributes(attributes)
        form.valid?
        form.save

        expect(form.errors.messages_for(:date_received)).to include("Enter a valid date, like 1 1 2025")
      end
    end
  end
end
