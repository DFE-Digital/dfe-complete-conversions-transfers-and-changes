require "rails_helper"

RSpec.describe Statistics::UserStatistics, type: :model do
  subject { Statistics::UserStatistics.new }

  before do
    User.destroy_all
  end

  describe "#users_count_per_team" do
    it "returns counts of users per team" do
      create(:user, email: "user1@education.gov.uk", team: "london")
      create(:user, email: "user2@education.gov.uk", team: "regional_casework_services")
      create(:user, email: "user3@education.gov.uk", team: "south_west")
      create(:user, email: "user4@education.gov.uk", team: "service_support")
      create(:user, email: "user5@education.gov.uk", team: "north_east")
      create(:user, email: "user6@education.gov.uk", team: "north_east")
      create(:user, email: "user7@education.gov.uk", team: "data_consumers")
      create(:user, email: "user8@education.gov.uk", team: "west_midlands")
      create(:user, email: "user9@education.gov.uk", team: "yorkshire_and_the_humber")

      expect(subject.users_count_per_team).to eq({
        business_support: 0,
        data_consumers: 1,
        east_midlands: 0,
        east_of_england: 0,
        london: 1,
        north_east: 2,
        north_west: 0,
        regional_casework_services: 1,
        service_support: 1,
        south_east: 0,
        south_west: 1,
        west_midlands: 1,
        yorkshire_and_the_humber: 1
      })
    end
  end
end
