require "rails_helper"

RSpec.describe Transfer::TasksData, type: :model do
  describe ".policy_class" do
    it "returns the correct policy" do
      expect(described_class.policy_class).to eql(TaskListPolicy)
    end
  end
end
