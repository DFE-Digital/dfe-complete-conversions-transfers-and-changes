require "rails_helper"

RSpec.describe AssignmentsHelper, type: :helper do
  describe "#full_name_and_email" do
    let(:user) { create(:user) }

    subject { helper.full_name_and_email(user) }

    it "returns the users full name followed by their parenthesised email" do
      expect(subject).to eq "John Doe (user@education.gov.uk)"
    end
  end
end
