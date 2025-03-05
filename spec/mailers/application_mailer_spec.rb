require "rails_helper"

RSpec.describe ApplicationMailer do
  before { mock_successful_api_responses(urn: any_args, ukprn: 10061021) }

  describe "#url_to_project" do
    it "returns the correct url" do
      project = create(:conversion_project)
      mailer = ApplicationMailer.new

      expect(mailer.url_to_project(project)).to eql project_url(project)
    end
  end
end
