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
      let(:contacts) { [build(:project_contact)] }

      it "returns true" do
        expect(helper.has_contacts?(contacts)).to be true
      end
    end
  end
end
