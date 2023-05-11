require "rails_helper"

RSpec.describe LocalAuthorityHelper, type: :helper do
  describe "#address_markup" do
    context "when viewing a local authority" do
      it "returns the address on mutiple lines" do
        local_authority = build(:local_authority)
        markup = address_markup(local_authority.address)

        expect(markup).to include("#{local_authority.address_1}<br/>")
        expect(markup).to include("#{local_authority.address_2}<br/>")
        expect(markup).to include("#{local_authority.address_town}<br/>")
        expect(markup).to include("#{local_authority.address_county}<br/>")
        expect(markup).to include(local_authority.address_postcode.to_s)
      end
    end
  end
end
