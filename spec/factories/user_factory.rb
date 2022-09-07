FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    first_name { "John" }
    last_name { "Doe" }
    team_leader { false }
    regional_delivery_officer { false }
    caseworker { false }

    trait :caseworker do
      email { "caseworker@education.gov.uk" }
      caseworker { true }
    end

    trait :team_leader do
      first_name { "Team" }
      last_name { "Leader" }
      team_leader { true }
      email { "team.lead@education.gov.uk" }
    end

    trait :regional_delivery_officer do
      first_name { "Regional" }
      last_name { "Delivery-Officer" }
      regional_delivery_officer { true }
      email { "regional.delivery.officer@education.gov.uk" }
    end
  end
end
