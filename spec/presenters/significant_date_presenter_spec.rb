require "rails_helper"

RSpec.describe SignificantDatePresenter do
  before do
    mock_all_academies_api_responses
  end

  describe "title" do
    it "presents the created at date and time in right format" do
      date_history = create(:date_history, created_at: Time.zone.local(2024, 6, 1, 12, 0, 0))

      presenter = described_class.new(date_history)

      expect(presenter.title).to eql "1 June 2024 12:00"
    end
  end

  describe "#user_email" do
    it "presents the user email" do
      user = create(:user)
      date_history = create(:date_history, user: user)

      presenter = described_class.new(date_history)

      expect(presenter.user_email).to eql user.email
    end
  end

  describe "#to_date" do
    it "presents the revised date in the right format" do
      date_history = create(:date_history, revised_date: Date.new(2024, 9, 1))

      presenter = described_class.new(date_history)

      expect(presenter.to_date).to eql "1 September 2024"
    end
  end

  describe "#from_date" do
    it "presents the previous date in the right format" do
      date_history = create(:date_history, previous_date: Date.new(2024, 8, 1))

      presenter = described_class.new(date_history)

      expect(presenter.from_date).to eql "1 August 2024"
    end
  end
end
