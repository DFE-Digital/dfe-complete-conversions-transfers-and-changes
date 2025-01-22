require "rails_helper"

RSpec.describe HandleBadQuery do
  let(:app) { double(call: nil) }
  let(:middleware) { HandleBadQuery.new(app) }

  context "when the QUERY_STRING causes a decoding error" do
    it "sets the QUERY_STRING to the homepage" do
      middleware.call(
        "QUERY_STRING" => "x=&x%5B%5D=a"
      )

      expect(app).to have_received(:call).with(
        "QUERY_STRING" => ""
      )
    end
  end

  context "when the QUERY_STRING causes NO decoding error" do
    it "leaves the QUERY_STRING unchanged" do
      middleware.call(
        "QUERY_STRING" => "filter=active"
      )

      expect(app).to have_received(:call).with(
        "QUERY_STRING" => "filter=active"
      )
    end
  end
end
