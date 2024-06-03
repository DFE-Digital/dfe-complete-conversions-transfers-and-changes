FactoryBot.define do
  factory :gias_establishment, class: "Gias::Establishment" do
    urn { 144731 }
    ukprn { 10065250 }
    name { "The Lanes Primary School" }
    establishment_number { 2031 }
    local_authority_name { "Nottinghamshire" }
    local_authority_code { 891 }
    region_name { "East Midlands" }
    region_code { "E" }
    type_name { "Community school" }
    type_code { 1 }
    age_range_lower { 5 }
    age_range_upper { 11 }
    phase_name { "Primary" }
    phase_code { 2 }
    diocese_name { nil }
    diocese_code { nil }
    parliamentary_constituency_name { "Broxtowe" }
    parliamentary_constituency_code { "E07000172" }
    address_street { "Cator Lane" }
    address_locality { "Chilwell" }
    address_additional { "Beeston" }
    address_town { "Nottingham" }
    address_county { "Nottinghamshire" }
    address_postcode { "NG9 4BB" }
    url { "www.thelanes.notts.sch.uk" }
    status { "open" }
    open_date { Date.new(1999, 1, 1) }

    trait :with_diocese do
      urn { 142323 }
      ukprn { 10080750 }
      name { "Dagnall VA Church of England School" }
      establishment_number { 2022 }
      local_authority_name { "Buckinghamshire" }
      local_authority_code { 825 }
      region_name { "South East" }
      region_code { "J" }
      type_name { "Voluntary aided school" }
      type_code { 2 }
      age_range_lower { 4 }
      age_range_upper { 11 }
      phase_name { "Primary" }
      phase_code { 2 }
      diocese_name { "Diocese of St Albans" }
      diocese_code { "CE32" }
      parliamentary_constituency_name { "Buckingham" }
      parliamentary_constituency_code { "E14000608" }
      address_street { "Main Road South" }
      address_locality { nil }
      address_additional { "Berkhamsted" }
      address_town { "Dagnall" }
      address_county { "Buckinghamshire" }
      address_postcode { "HP4 1QX" }
      url { "www.dagnall.bucks.sch.uk" }
    end
  end
end
