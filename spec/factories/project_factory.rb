FactoryBot.define do
  factory :project, class: "Project" do
    urn { 12345 }
    trust_ukprn { 10061021 }
    target_completion_date { Date.new(2025, 12, 1) }
    team_leader { association :user, :team_leader, email: "team-leader-#{SecureRandom.uuid}@education.gov.uk" }
    regional_delivery_officer { association :user, :regional_delivery_officer, email: "regional-delivery-officer-#{SecureRandom.uuid}@education.gov.uk" }
  end
end
