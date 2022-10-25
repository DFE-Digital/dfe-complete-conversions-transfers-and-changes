require "rails_helper"

RSpec.describe Task, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
    it { is_expected.to have_db_column(:completed).of_type :boolean }
    it { is_expected.to have_db_column(:optional).of_type :boolean }
    it { is_expected.to have_db_column(:not_applicable).of_type :boolean }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:section) }
    it { is_expected.to have_many(:actions).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
  end

  describe "Scopes" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    describe "default_scope" do
      let!(:task_1) { create(:task, order: 1) }
      let!(:task_2) { create(:task, order: 0) }

      it "orders ascending by the 'order' attribute" do
        expect(Task.all).to eq [task_2, task_1]
      end
    end
  end

  describe "#actions_count" do
    let(:task) { create(:task) }

    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
      FactoryBot.create_list(:action, 3, task:)
    end

    it "returns the number of actions associated with the task" do
      expect(task.actions_count).to eq 3
    end
  end

  describe "#completed_actions_count" do
    let(:task) { create(:task) }

    before do
      mock_successful_api_responses(urn: any_args, ukprn: any_args)
      FactoryBot.create_list(:action, 1, task:)
      FactoryBot.create_list(:action, 2, task:, completed: true)
    end

    it "returns the number of completed actions associated with the task" do
      expect(task.completed_actions_count).to eq 2
    end
  end

  describe "#status" do
    let(:task) { create(:task) }

    context "there are no completed actions" do
      before do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        FactoryBot.create_list(:action, 3, task:)
      end

      it "returns a not_started state" do
        expect(task.status).to eq :not_started
      end
    end

    context "the number of completed actions is equal to the total number of actions" do
      before do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        FactoryBot.create_list(:action, 3, task:, completed: true)
      end

      it "returns a completed state" do
        expect(task.status).to eq :completed
      end
    end

    context "there are fewer completed actions than the total number of actions" do
      before do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        FactoryBot.create_list(:action, 1, task:)
        FactoryBot.create_list(:action, 2, task:, completed: true)
      end

      it "returns an in_progress state" do
        expect(task.status).to eq :in_progress
      end
    end

    context "when the task is not applicable" do
      let(:task) { create(:task, not_applicable: true, optional: true) }

      before do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
      end

      it "returns an not_applicable state" do
        expect(task.status).to eq :not_applicable
      end
    end
  end
end
