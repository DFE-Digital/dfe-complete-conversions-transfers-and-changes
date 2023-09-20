require "rails_helper"

RSpec.describe Event do
  let(:user) { create(:user) }

  describe ".log" do
    it "can create system events" do
      result = Event.log(grouping: :system, user: user, message: "A test system event")

      expect(result).to be_a(Event)
      expect(result.message).to eql("A test system event")
      expect(result.system?).to be true
      expect(result.user).to be user
    end

    it "can create project events" do
      mock_all_academies_api_responses

      project = build(:conversion_project)
      result = Event.log(
        grouping: :project,
        user: user,
        message: "A test project event",
        with: project
      )

      expect(result).to be_a(Event)
      expect(result.message).to eql("A test project event")
      expect(result.project?).to be true
      expect(result.user).to be user
      expect(result.eventable).to be project
    end

    it "raises an error if the grouping is not valid" do
      expect {
        Event.log(grouping: :not_a_grouping, user: user, message: "A test project event")
      }.to raise_error(ArgumentError)
    end

    it "raises an error if no Project is given for a project event" do
      expect {
        Event.log(grouping: :project, user: user, message: "A test project event")
      }.to raise_error(ArgumentError)
    end
  end
end
