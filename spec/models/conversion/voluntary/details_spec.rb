require "rails_helper"

RSpec.describe Conversion::Voluntary::Details do
  describe "#route" do
    it "returns the locale for the voluntary route" do
      details = described_class.new

      expect(details.route).to eql I18n.t("conversion_project.voluntary.route")
    end
  end
end
