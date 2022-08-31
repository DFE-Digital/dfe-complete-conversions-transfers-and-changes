require "rails_helper"

RSpec.describe ContactsHelper, type: :helper do
  describe "#has_contacts?" do
    context "when contacts is nil" do
      let(:contacts) { nil }

      it "returns false" do
        expect(helper.has_contacts?(contacts)).to be false
      end
    end

    context "when contacts is an empty array" do
      let(:contacts) { [] }

      it "returns false" do
        expect(helper.has_contacts?(contacts)).to be false
      end
    end

    context "when there are contacts" do
      let(:contacts) { [build(:contact)] }

      it "returns true" do
        expect(helper.has_contacts?(contacts)).to be true
      end
    end
  end

  describe "#format_category_name" do
    context "given a category name" do
      let(:category_name) { "test_category_with_spaces" }

      it "formats the category name as expected" do
        expect(helper.format_category_name(category_name)).to eq "Test category with spaces"
      end
    end
  end
end
