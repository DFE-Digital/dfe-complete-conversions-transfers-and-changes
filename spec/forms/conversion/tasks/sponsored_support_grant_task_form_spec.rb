require "rails_helper"

RSpec.describe Conversion::Task::SponsoredSupportGrantTaskForm do
  let(:user) { create(:user) }
  let(:project) { create(:conversion_project) }

  describe "#save" do
    before { mock_successful_api_response_to_create_any_project }

    it "clears the value of 'type' if 'Not applicable' is ticked" do
      form = described_class.new(project.tasks_data, user)
      form.assign_attributes(type: "fast_track")
      form.save

      expect(project.tasks_data.sponsored_support_grant_type).to eq("fast_track")

      form.assign_attributes(not_applicable: true)
      form.save

      expect(project.tasks_data.sponsored_support_grant_type).to be_nil
    end
  end
end
