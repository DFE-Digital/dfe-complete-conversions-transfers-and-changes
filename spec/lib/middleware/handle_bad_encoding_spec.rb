require "rails_helper"

RSpec.describe HandleBadEncoding do
  let(:app) { double(call: nil) }
  let(:middleware) { HandleBadEncoding.new(app) }

  context "when the REQUEST_URI causes a decoding error" do
    it "sets the PATH_INFO to the homepage" do
      middleware.call(
        "REQUEST_URI" => "/%ff",
        "PATH_INFO" => "/%ff"
      )

      expect(app).to have_received(:call).with(
        "REQUEST_URI" => "/%ff",
        "PATH_INFO" => "/"
      )
    end
  end

  context "when the REQUEST_URI causes NO decoding error" do
    it "leaves the PATH_INFO unchanged" do
      middleware.call(
        "REQUEST_URI" => "/path/to/resource",
        "PATH_INFO" => "/path/to/resource"
      )

      expect(app).to have_received(:call).with(
        "REQUEST_URI" => "/path/to/resource",
        "PATH_INFO" => "/path/to/resource"
      )
    end
  end
end
