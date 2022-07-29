require "rails_helper"

RSpec.describe Section, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
  end

  describe "Relationships" do
    it { is_expected.to have_many(:tasks).dependent(:destroy) }
    it { is_expected.to belong_to(:project) }
  end

  describe "Scopes" do
    before { mock_successful_api_responses(urn: any_args) }

    describe "default_scope" do
      let!(:section_1) { create(:section, order: 1) }
      let!(:section_2) { create(:section, order: 0) }

      it "orders ascending by the 'order' attribute" do
        expect(Section.all).to eq [section_2, section_1]
      end
    end
  end
end
