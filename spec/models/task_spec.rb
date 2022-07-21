require "rails_helper"

RSpec.describe Task, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
    it { is_expected.to have_db_column(:completed).of_type :boolean }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:section) }
    it { is_expected.to have_many(:actions).dependent(:destroy) }
  end

  describe "Scopes" do
    before { mock_successful_api_responses(urn: any_args) }

    describe "default_scope" do
      let!(:task_1) { create(:task, order: 1) }
      let!(:task_2) { create(:task, order: 0) }

      it "orders ascending by the 'order' attribute" do
        expect(Task.all).to eq [task_2, task_1]
      end
    end
  end
end
