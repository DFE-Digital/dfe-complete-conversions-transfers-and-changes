FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    first_name { "John" }
    last_name { "Doe" }
    team_leader { false }
    add_new_project { false }
    service_support { false }
    assign_to_project { false }
    team { "academies_operational_practice_unit" }

    trait :caseworker do
      email { "caseworker-#{SecureRandom.uuid}@education.gov.uk" }
      assign_to_project { true }
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
      add_new_project { true }
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

    factory :regional_delivery_officer do
      first_name { "Regional" }
      last_name { "Delivery-Officer" }
      email { "regional.delivery-officer@education.gov.uk" }
      assign_to_project { true }
      add_new_project { true }
      team { "north_west" }
    end

    factory :regional_caseworker_user do
      first_name { "Regional" }
      last_name { "Caseworker" }
      email { "regional.caseworker@education.gov.uk" }
      assign_to_project { true }
      team { "regional_casework_services" }
    end

    factory :inactive_user do
      first_name { "Inactive" }
      last_name { "User" }
      email { "inactive.user@education.gov.uk" }
      deactivated_at { Date.today }
    end
  end
end
