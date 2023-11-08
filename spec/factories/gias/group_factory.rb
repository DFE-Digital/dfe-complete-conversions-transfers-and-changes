FactoryBot.define do
  factory :gias_group, class: "Gias::Group" do
    unique_group_identifier { 1234 }
    ukprn { 10061021 }
    companies_house_number { "09702162" }
    group_identifier { "TR03094" }
    original_name { "The Academy Group" }
    address_street { "Academy Lane" }
    address_locality { "Chilwell" }
    address_additional { "Beeston" }
    address_town { "Nottingham" }
    address_county { "Nottinghamshire" }
    address_postcode { "NG1 4PQ" }
  end
end
