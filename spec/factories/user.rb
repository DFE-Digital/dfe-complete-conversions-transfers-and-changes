FactoryBot.define do
  factory :user do
    email { "user@education.gov.uk" }
    team_leader { false }
  end
end
