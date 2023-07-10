FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    first_name { "John" }
    last_name { "Doe" }
    team_leader { false }
    regional_delivery_officer { false }
    service_support { false }
    caseworker { false }
    team { "academies_operational_practice_unit" }

    trait :caseworker do
      email { "caseworker-#{SecureRandom.uuid}@education.gov.uk" }
      caseworker { true }
      team { "regional_casework_services" }
    end

    trait :team_leader do
      first_name { "Team" }
      last_name { "Leader" }
      team_leader { true }
      email { "team-leader-#{SecureRandom.uuid}@education.gov.uk" }
      team { "regional_casework_services" }
    end

    trait :regional_delivery_officer do
      first_name { "Regional" }
      last_name { "Delivery-Officer" }
      regional_delivery_officer { true }
      email { "regional-delivery-officer-#{SecureRandom.uuid}@education.gov.uk" }
      team { "london" }
    end

    trait :service_support do
      first_name { "Service" }
      last_name { "Support" }
      service_support { true }
      email { "service-support-#{SecureRandom.uuid}@education.gov.uk" }
      team { "service_support" }
    end

    factory :inactive_user do
      first_name { "Inactive" }
      last_name { "User" }
      email { "inactive.user@education.gov.uk" }
      deactivated_at { Date.today }
    end
  end
end
