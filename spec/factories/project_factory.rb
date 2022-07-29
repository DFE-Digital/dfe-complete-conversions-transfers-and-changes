FactoryBot.define do
  factory :project, class: "Project" do
    urn { 12345 }
    team_leader { association :user, :team_leader, email: "team-leader-#{SecureRandom.uuid}@education.gov.uk" }
  end
end
