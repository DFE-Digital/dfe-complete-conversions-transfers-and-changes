FactoryBot.define do
  factory :academies_api_trust, class: "Api::AcademiesApi::Trust" do
    ukprn { "10061021" }
    group_identifier { "TR100610" }
    original_name { "THE ROMERO CATHOLIC ACADEMY" }
    companies_house_number { "09702162" }
    address_street { "The Street" }
    address_locality { "Locality" }
    address_additional { "Additional" }
    address_town { "Town" }
    address_county { "County" }
    address_postcode { "PC1 PC2" }
  end
end
