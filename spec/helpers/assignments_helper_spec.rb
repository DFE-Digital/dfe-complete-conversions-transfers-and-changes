require "rails_helper"

RSpec.describe AssignmentsHelper, type: :helper do
  describe "#full_name_and_email" do
    let(:user) { create(:user) }

    subject { helper.full_name_and_email(user) }

    it "returns the users full name followed by their parenthesised email" do
      expect(subject).to eq "John Doe (user@education.gov.uk)"
    end
  end

  describe "all_eligible_users" do
    let!(:user_1) { create(:user, regional_delivery_officer: true, email: "John.Doe@email.gov.uk") }
    let!(:user_2) { create(:user, regional_delivery_officer: true, team_leader: true, email: "Jane.Smith@email.gov.uk") }
    let!(:user_3) { create(:user, caseworker: true, email: "Bob.Jones@email.gov.uk") }
    let!(:user_4) { create(:user, team_leader: true, email: "Carol.Bloggs@email.gov.uk") }
    let!(:user_5) { create(:user, team_leader: true, caseworker: true, email: "Tony.Soprano@email.gov.uk") }

    it "returns a unique list of all caseworkers, team leaders and regional delivery officers" do
      expect(helper.all_eligible_users.count).to eq 5
    end
  end
end
