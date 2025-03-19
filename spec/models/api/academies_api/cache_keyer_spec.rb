require "rails_helper"

RSpec.describe Api::AcademiesApi::CacheKeyer do
  describe "::for_path(path:, params: nil)" do
    before do
      allow(Digest::SHA1).to receive(:hexdigest).and_return("SHA")
    end

    context "when params are NOT included" do
      it "uses only the supplied path to generate a SHA" do
        Api::AcademiesApi::CacheKeyer.for_path(path: "/v4/establishment/urn/123456")

        expect(Digest::SHA1).to have_received(:hexdigest).with("/v4/establishment/urn/123456")
      end
    end

    context "when params ARE included" do
      it "uses both supplied path and params to generate a SHA" do
        Api::AcademiesApi::CacheKeyer.for_path(
          path: "/v4/establishment/urn/123456",
          params: {request: [123456, 333333]}
        )

        expect(Digest::SHA1).to have_received(:hexdigest).with(
          "/v4/establishment/urn/123456 {request: [123456, 333333]}"
        )
      end
    end

    context "when params are NIL" do
      it "uses only the supplied path to generate a SHA" do
        Api::AcademiesApi::CacheKeyer.for_path(
          path: "/v4/establishment/urn/123456",
          params: nil
        )

        expect(Digest::SHA1).to have_received(:hexdigest).with(
          "/v4/establishment/urn/123456"
        )
      end
    end
  end
end
