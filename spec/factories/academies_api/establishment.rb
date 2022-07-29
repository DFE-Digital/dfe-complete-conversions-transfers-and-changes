FactoryBot.define do
  factory :academies_api_establishment, class: "AcademiesApi::Establishment" do
    name { "Caludon Castle School" }
    local_authority { "West Placefield Council" }
    type { "Academy converter" }
  end
end
