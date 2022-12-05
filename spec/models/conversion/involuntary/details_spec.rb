require "rails_helper"

RSpec.describe Conversion::Involuntary::Details do
  describe "#route" do
    it "returns the locale for the involuntary route" do
      details = described_class.new

      expect(details.route).to eql I18n.t("conversion_project.involuntary.route")
    end
  end
end
