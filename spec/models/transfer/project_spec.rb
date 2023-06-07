require "rails_helper"

RSpec.describe Transfer::Project do
  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(ProjectPolicy)
    end
  end
end
