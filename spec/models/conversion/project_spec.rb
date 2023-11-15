require "rails_helper"

RSpec.describe Conversion::Project do
  before { mock_successful_api_response_to_create_any_project }

  describe "validations" do
    describe "academy urn" do
      context "when there is no academy urn" do
        it "is valid" do
          project = build(:conversion_project, academy_urn: nil)

          expect(project).to be_valid
        end
      end

      context "when there is an academy urn" do
        it "the urn must be valid" do
          project = build(:conversion_project, academy_urn: 12345678)

          expect(project).to be_invalid

          project = build(:conversion_project, academy_urn: 123456)

          expect(project).to be_valid
        end
      end
    end

    describe "#directive_academy_order" do
      it { is_expected.to allow_value(true).for(:directive_academy_order) }
      it { is_expected.to allow_value(false).for(:directive_academy_order) }
      it { is_expected.to_not allow_value(nil).for(:directive_academy_order) }

      context "error messages" do
        it "adds an appropriate error message if the value is nil" do
          subject.assign_attributes(directive_academy_order: nil)
          subject.valid?
          expect(subject.errors[:directive_academy_order]).to include("Select directive academy order or academy order, whichever has been used for this conversion")
        end
      end
    end

    describe "#two_requires_improvement" do
      it { is_expected.to allow_value(true).for(:two_requires_improvement) }
      it { is_expected.to allow_value(false).for(:two_requires_improvement) }
      it { is_expected.to_not allow_value(nil).for(:two_requires_improvement) }
    end
  end

  describe "scopes" do
    describe ".no_academy_urn" do
      it "returns only projects where academy_urn is nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Conversion::Project.no_academy_urn

        expect(projects).to include(new_project)
        expect(projects).not_to include(existing_project)
      end
    end

    describe ".with_academy_urn" do
      it "returns only projects where academy_urn is NOT nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Conversion::Project.with_academy_urn

        expect(projects).to include(existing_project)
        expect(projects).not_to include(new_project)
      end
    end

    describe ".by_conversion_date" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "shows the project that will convert earliest first" do
        last_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 3.years)
        middle_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 2.years)
        first_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 1.year)

        scoped_projects = Conversion::Project.by_conversion_date

        expect(scoped_projects[0].id).to eq first_project.id
        expect(scoped_projects[1].id).to eq middle_project.id
        expect(scoped_projects[2].id).to eq last_project.id
      end
    end
  end

  describe "#conversion_date" do
    it { is_expected.to validate_presence_of(:conversion_date) }

    context "when the date is not on the first of the month" do
      subject { build(:conversion_project, conversion_date: Date.today.months_since(6).at_end_of_month) }

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:conversion_date]).to include(I18n.t("errors.attributes.conversion_date.must_be_first_of_the_month"))
      end
    end
  end

  describe "#grant_payment_certificate_received?" do
    let(:user) { create(:user) }
    let(:project) { build(:conversion_project, tasks_data: tasks_data) }

    context "when the ReceiveGrantPaymentCertificateTaskForm is NOT completed" do
      let(:tasks_data) {
        create(:conversion_tasks_data,
          receive_grant_payment_certificate_check_and_save: nil,
          receive_grant_payment_certificate_update_kim: nil)
      }

      it "returns false" do
        expect(project.grant_payment_certificate_received?).to be false
      end
    end

    context "when the ReceiveGrantPaymentCertificateTaskForm is completed" do
      let(:tasks_data) {
        create(:conversion_tasks_data,
          receive_grant_payment_certificate_check_and_save: true,
          receive_grant_payment_certificate_update_kim: true)
      }

      it "returns true" do
        expect(project.grant_payment_certificate_received?).to be true
      end
    end
  end

  describe "#academy" do
    it "returns an establishment object when the urn can be found" do
      mock_successful_api_response_to_create_any_project

      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy).to be_a(Api::AcademiesApi::Establishment)
    end

    it "returns nil when the urn cannot be found" do
      mock_successful_api_response_to_create_any_project
      mock_establishment_not_found(urn: 999999)

      project = build(:conversion_project, academy_urn: 999999)

      expect(project.academy).to be_nil
    end
  end

  describe "#academy_found?" do
    before { mock_successful_api_response_to_create_any_project }

    it "returns true when the academy can be found" do
      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy_found?).to eql true
    end

    it "returns false when the academy cannot be found" do
      project = build(:conversion_project, academy_urn: 123456)

      allow_any_instance_of(Conversion::Project).to receive(:academy).and_return(nil)

      expect(project.academy_found?).to eql false
    end
  end

  describe "#academy_order_type" do
    context "when the project has an Academy order" do
      it "returns academy_order" do
        project = create(:conversion_project, directive_academy_order: false)
        expect(project.academy_order_type).to eq(:academy_order)
      end
    end

    context "when the project has a Directive academy order" do
      it "returns directive_academy_order" do
        project = create(:conversion_project, directive_academy_order: true)
        expect(project.academy_order_type).to eq(:directive_academy_order)
      end
    end
  end
end
