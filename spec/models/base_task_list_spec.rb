require "rails_helper"

RSpec.describe BaseTaskList do
  describe ".layout" do
    it "must be implemented by all sub-classes" do
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project)
      user = create(:user)

      expect { BaseTaskLisSubClassTestClass.new(project, user) }.to raise_error(NotImplementedError)
    end
  end
end

class BaseTaskLisSubClassTestClass < BaseTaskList
end
