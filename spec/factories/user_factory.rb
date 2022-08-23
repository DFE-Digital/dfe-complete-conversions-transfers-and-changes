FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    team_leader { false }
    regional_delivery_officer { false }

    trait :caseworker do
      email { "caseworker@education.gov.uk" }
    end

    trait :team_leader do
      team_leader { true }
      email { "team.lead@education.gov.uk" }
    end

    trait :regional_delivery_officer do
      regional_delivery_officer { true }
      email { "regional.delivery.officer@education.gov.uk" }
    end
  end
end
