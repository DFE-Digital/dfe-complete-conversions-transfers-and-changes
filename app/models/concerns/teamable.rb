module Teamable
  extend ActiveSupport::Concern

  REGIONAL_TEAMS = {
    london: "london",
    south_east: "south_east",
    yorkshire_and_the_humber: "yorkshire_and_the_humber",
    north_west: "north_west",
    east_of_england: "east_of_england",
    west_midlands: "west_midlands",
    north_east: "north_east",
    south_west: "south_west",
    east_midlands: "east_midlands"
  }

  USER_TEAMS = REGIONAL_TEAMS.merge({
    regional_casework_services: "regional_casework_services",
    service_support: "service_support",
    academies_operational_practice_unit: "academies_operational_practice_unit",
    education_and_skills_funding_agency: "education_and_skills_funding_agency",
    business_support: "business_support",
    data_consumers: "data_consumers"
  })

  PROJECT_TEAMS = REGIONAL_TEAMS.merge({regional_casework_services: "regional_casework_services"})

  class_methods do
    def regional_teams
      REGIONAL_TEAMS.values
    end
  end
end
