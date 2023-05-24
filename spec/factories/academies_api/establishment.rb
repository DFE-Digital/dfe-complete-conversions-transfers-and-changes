FactoryBot.define do
  factory :academies_api_establishment, class: "Api::AcademiesApi::Establishment" do
    urn { "123456" }
    name { "Caludon Castle School" }
    establishment_number { "1234" }
    local_authority_name { "West Placefield Council" }
    local_authority_code { "894" }
    type { "Academy converter" }
    age_range_lower { 11 }
    age_range_upper { 18 }
    phase { "Secondary" }
    diocese_name { "Diocese of West Placefield" }
    region_name { "West Midlands" }
    region_code { "F" }
    address_street { "The Street" }
    address_locality { "Locality" }
    address_additional { "Additional" }
    address_town { "Town" }
    address_county { "County" }
    address_postcode { "PC1 PC2" }
  end
end
