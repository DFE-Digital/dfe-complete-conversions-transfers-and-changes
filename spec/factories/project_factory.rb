FactoryBot.define do
  factory :project, class: "Project" do
    urn { 123456 }
    incoming_trust_ukprn { 10061021 }
    target_completion_date { (Date.today + 2.years).at_beginning_of_month }
    team_leader { association :user, :team_leader, email: "team-leader-#{SecureRandom.uuid}@education.gov.uk" }
    regional_delivery_officer { association :user, :regional_delivery_officer, email: "regional-delivery-officer-#{SecureRandom.uuid}@education.gov.uk" }
  end
end
