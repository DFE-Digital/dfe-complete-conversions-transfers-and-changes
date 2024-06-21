require "rails_helper"

RSpec.describe ContactEstablishmentDataMigration do
  it "updates the `category` of all Contact::Establishment records" do
    contact = create(:establishment_contact, category: "other")

    described_class.new.migrate!

    expect(contact.reload.category).to eq("school_or_academy")
  end
end
