require "rails_helper"

RSpec.describe Transfer::Project do
  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(ProjectPolicy)
    end
  end

  describe "#outgoing_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:outgoing_trust_ukprn) }

    context "when the outgoing_trust_ukprn is not a number" do
      subject { described_class.new(outgoing_trust_ukprn: "Super Schools Trust") }

      it "is invalid" do
        expect(subject).to_not be_valid
        expect(subject.errors[:outgoing_trust_ukprn]).to include(I18n.t("errors.attributes.outgoing_trust_ukprn.must_be_correct_format"))
      end
    end
  end

  describe "#completable?" do
    let(:project) { create(:transfer_project) }

    before do
      mock_successful_api_response_to_create_any_project

      allow(project).to receive(:confirmed_date_and_in_the_past?).and_return(true)
      allow(project).to receive(:authority_to_proceed?).and_return(true)
      allow(project).to receive(:declaration_of_expenditure_certificate_task_completed?).and_return(true)
      allow(project).to receive(:confirm_date_academy_transferred_task_completed?).and_return(true)
    end

    it "returns true when all the mandatory conditions are completed" do
      expect(project.completable?).to eq true
    end

    it "returns false if the transfer date is in the future" do
      allow(project).to receive(:confirmed_date_and_in_the_past?).and_return(false)

      expect(project.completable?).to eq false
    end

    it "returns false if the the project has not got authority to proceed" do
      allow(project).to receive(:authority_to_proceed?).and_return(false)

      expect(project.completable?).to eq false
    end

    it "returns false if the declaration of expenditure task is incomplete" do
      allow(project).to receive(:declaration_of_expenditure_certificate_task_completed?).and_return(false)

      expect(project.completable?).to eq false
    end

    it "returns false if the confirm date academy openend task is incomplete" do
      allow(project).to receive(:confirm_date_academy_transferred_task_completed?).and_return(false)

      expect(project.completable?).to eq false
    end
  end

  describe "#declaration_of_expenditure_certificate_task_completed?" do
    before do
      mock_all_academies_api_responses
    end

    let(:user) { create(:user) }
    let(:tasks_data) {
      create(:transfer_tasks_data,
        declaration_of_expenditure_certificate_date_received: Date.today,
        declaration_of_expenditure_certificate_correct: true,
        declaration_of_expenditure_certificate_saved: true,
        declaration_of_expenditure_certificate_not_applicable: false)
    }
    let(:project) { create(:transfer_project, tasks_data: tasks_data) }

    context "when the task is completed" do
      it "returns true" do
        expect(project.declaration_of_expenditure_certificate_task_completed?).to be true
      end
    end

    context "when the task is not applicable" do
      before do
        allow(tasks_data)
          .to receive(:declaration_of_expenditure_certificate_not_applicable)
          .and_return(true)
      end

      it "returns true" do
        expect(project.declaration_of_expenditure_certificate_task_completed?).to be true
      end
    end

    context "when the task is not completed" do
      before do
        allow(tasks_data)
          .to receive(:declaration_of_expenditure_certificate_date_received)
          .and_return(nil)
      end

      it "returns false" do
        expect(project.declaration_of_expenditure_certificate_task_completed?).to be false
      end
    end
  end

  describe "#confirm_date_academy_transferred_task_completed?" do
    before do
      mock_all_academies_api_responses
    end

    let(:user) { create(:user) }
    let(:tasks_data) {
      create(:transfer_tasks_data,
        confirm_date_academy_transferred_date_transferred: Date.today)
    }
    let(:project) { create(:transfer_project, tasks_data: tasks_data) }

    context "when the task is completed" do
      it "returns true" do
        expect(project.confirm_date_academy_transferred_task_completed?).to be true
      end
    end

    context "when the task is NOT completed" do
      before do
        allow(tasks_data)
          .to receive(:confirm_date_academy_transferred_date_transferred)
          .and_return(nil)
      end

      it "returns false" do
        expect(project.confirm_date_academy_transferred_task_completed?).to be false
      end
    end
  end
end
