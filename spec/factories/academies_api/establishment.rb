FactoryBot.define do
  factory :academies_api_establishment, class: "AcademiesApi::Establishment" do
    urn { "123456" }
    name { "Caludon Castle School" }
    local_authority { "West Placefield Council" }
    type { "Academy converter" }
    age_range_lower { 11 }
    age_range_upper { 18 }
    phase { "Secondary" }
    diocese_name { "Diocese of West Placefield" }
    region_name { "West Midlands" }
  end
end
