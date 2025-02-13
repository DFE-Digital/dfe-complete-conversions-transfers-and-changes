require "rails_helper"

RSpec.describe Capability do
  describe "enforces presence of #name and #description" do
    let(:capability) do
      Capability.new(name: nil, description: nil).tap do |capability|
        capability.valid?
      end
    end

    it "is invalid without #name" do
      expect(capability.errors.full_messages).to include("Name can't be blank")
    end

    it "is invalid without #description" do
      expect(capability.errors.full_messages).to include("Description can't be blank")
    end
  end
  describe "enforces uniqueness of #name" do
    context "when a capability with the same name already exists" do
      before do
        Capability.create(
          name: :can_do_it,
          description: "Can do it"
        )
      end

      it("will not be valid") do
        new_capability = Capability.new(
          name: :can_do_it,
          description: "Also can do it"
        )

        expect(new_capability.valid?).to be false
      end
    end
  end
end
