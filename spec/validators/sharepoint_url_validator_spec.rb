require "rails_helper"

RSpec.describe SharepointUrlValidator do
  let(:link) { "https://example.com" }
  let(:testing_model) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :link
      validates :link, sharepoint_url: true
    end
  end

  subject { testing_model.new(link: link) }

  context "when the URL is an invalid URI" do
    let(:link) { "/[invalid]" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :invalid
    end
  end

  context "when the URL scheme is not https" do
    let(:link) { "http://example.com" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :https_only
    end
  end

  context "when the URL hostname does not match" do
    let(:link) { "https://something-else.com" }

    it "is invalid" do
      expect(subject.valid?).to be false
      expect(subject.errors.first.type).to be :host_not_allowed
    end
  end

  context "when the URL matches the hostname and scheme" do
    let(:link) { "https://educationgovuk.sharepoint.com" }

    it "is valid" do
      expect(subject.valid?).to be true
    end
  end
end
