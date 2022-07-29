FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    team_leader { false }

    trait :team_leader do
      team_leader { true }
    end
  end
end
