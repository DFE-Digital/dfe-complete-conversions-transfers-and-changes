require "rails_helper"

RSpec.describe Action do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
    it { is_expected.to have_db_column(:completed).of_type :boolean }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:task) }
  end

  describe "Scopes" do
    before { mock_successful_api_responses(urn: any_args) }

    describe "default_scope" do
      let!(:action_1) { create(:action, order: 1) }
      let!(:action_2) { create(:action, order: 0) }

      it "orders ascending by the 'order' attribute" do
        expect(Action.all).to eq [action_2, action_1]
      end
    end
  end
end
