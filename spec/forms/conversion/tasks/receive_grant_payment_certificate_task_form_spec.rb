require "rails_helper"

RSpec.describe Conversion::Task::ReceiveGrantPaymentCertificateTaskForm do
  let(:user) { create(:user) }

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    let(:project) { create(:conversion_project) }

    context "when the date is a valid date" do
      it "sets date_received to the supplied date" do
        form = described_class.new(project.tasks_data, user)
        form.assign_attributes("date_received(1i)": 2024, "date_received(2i)": 1, "date_received(3i)": 1)
        form.save

        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to eq(Date.new(2024, 1, 1))
      end

      it "sets date_received to the supplied date (leap year)" do
        form = described_class.new(project.tasks_data, user)
        form.assign_attributes("date_received(1i)": 2024, "date_received(2i)": 2, "date_received(3i)": 29)
        form.save

        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to eq(Date.new(2024, 2, 29))
      end
    end

    context "when the date is partially missing" do
      it "adds an error" do
        form = described_class.new(project.tasks_data, user)
        form.assign_attributes("date_received(1i)": 2024, "date_received(2i)": nil, "date_received(3i)": 1)

        expect(form.valid?).to be false
        expect(form.errors.messages[:date_received])
          .to include(I18n.t("conversion.task.receive_grant_payment_certificate.date_received.errors.format"))
        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to be_nil
      end
    end

    context "when the date is invalid" do
      it "adds an error" do
        form = described_class.new(project.tasks_data, user)
        form.assign_attributes("date_received(1i)": 2024, "date_received(2i)": 2, "date_received(3i)": 30)

        expect(form.valid?).to be false
        expect(form.errors.messages[:date_received])
          .to include(I18n.t("conversion.task.receive_grant_payment_certificate.date_received.errors.format"))
        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to be_nil
      end
    end

    context "when the date is totally missing" do
      it "saves without the date" do
        form = described_class.new(project.tasks_data, user)
        form.assign_attributes("date_received(1i)": nil, "date_received(2i)": nil, "date_received(3i)": nil)
        form.save

        expect(project.tasks_data.receive_grant_payment_certificate_date_received).to be_nil
      end
    end
  end
end
