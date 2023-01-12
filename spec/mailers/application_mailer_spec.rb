require "rails_helper"

RSpec.describe ApplicationMailer do
  before { mock_successful_api_responses(urn: 123456, ukprn: 10061021) }

  describe "#url_to_project" do
    context "when the conversion is involuntary" do
      it "returns the correct url" do
        project = create(:involuntary_conversion_project)
        mailer = ApplicationMailer.new

        expect(mailer.url_to_project(project)).to eq conversions_involuntary_project_url(project)
      end
    end

    context "when the conversion is voluntary" do
      it "returns the correct url" do
        project = create(:voluntary_conversion_project)
        mailer = ApplicationMailer.new

        expect(mailer.url_to_project(project)).to eql conversions_voluntary_project_url(project)
      end
    end
  end
end
