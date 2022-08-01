FactoryBot.define do
  factory :academies_api_establishment, class: "AcademiesApi::Establishment" do
    name { "Caludon Castle School" }
    local_authority { "West Placefield Council" }
    type { "Academy converter" }
    age_range_lower { 11 }
    age_range_upper { 18 }
    phase { "Secondary" }
  end
end
