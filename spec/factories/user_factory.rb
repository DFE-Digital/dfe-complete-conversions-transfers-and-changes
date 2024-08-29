FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    first_name { "John" }
    last_name { "Doe" }
    manage_team { false }
    add_new_project { false }
    assign_to_project { false }
    manage_user_accounts { false }
    manage_local_authorities { false }
    manage_conversion_urns { false }
    team { "data_consumers" }

    trait :caseworker do
      email { "caseworker-#{SecureRandom.uuid}@education.gov.uk" }
      assign_to_project { true }
      team { "regional_casework_services" }
    end

    trait :team_leader do
      first_name { "Team" }
      last_name { "Leader" }
      manage_team { true }
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
      email { "service-support-#{SecureRandom.uuid}@education.gov.uk" }
      team { "service_support" }
      manage_user_accounts { true }
      manage_local_authorities { true }
      manage_conversion_urns { true }
    end

    factory :regional_delivery_officer_team_lead_user do
      first_name { "Regional" }
      last_name { "Delivery-Officer" }
      email { "regional.delivery-officer@education.gov.uk" }
      assign_to_project { true }
      add_new_project { true }
      team { "north_west" }
      manage_team { true }
    end

    factory :regional_delivery_officer_user do
      first_name { "Regional" }
      last_name { "Delivery-Officer" }
      email { "regional.delivery-officer@education.gov.uk" }
      assign_to_project { true }
      add_new_project { true }
      team { "north_west" }
    end

    factory :regional_casework_services_team_lead_user do
      first_name { "Regional" }
      last_name { "Casework-Team-Lead" }
      email { "regional.casework-team-lead@education.gov.uk" }
      assign_to_project { false }
      manage_team { true }
      team { "regional_casework_services" }
    end

    factory :regional_casework_services_user do
      first_name { "Regional" }
      last_name { "Caseworker" }
      email { "regional.caseworker@education.gov.uk" }
      assign_to_project { true }
      team { "regional_casework_services" }
    end

    factory :service_support_user do
      first_name { "Service" }
      last_name { "Support" }
      email { "service.support@education.gov.uk" }
      team { "service_support" }
      manage_user_accounts { true }
      manage_local_authorities { true }
      manage_conversion_urns { true }
    end

    factory :inactive_user do
      first_name { "Inactive" }
      last_name { "User" }
      email { "inactive.user@education.gov.uk" }
      deactivated_at { Date.today }
    end
  end
end
