FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    team_leader { false }
    regional_delivery_officer { false }

    trait :team_leader do
      team_leader { true }
    end

    trait :regional_delivery_officer do
      regional_delivery_officer { true }
    end
  end
end
